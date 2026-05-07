const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const PROJECT_ROOT = path.resolve(__dirname, '../..'); // 部署到 .kanban/dashboard/ 后为项目根目录
// KANBAN_ROOT auto-detection:
//   Production (deployed to .kanban/dashboard/): __dirname/.. = .kanban/
//   Source (.claude/skills/kanban/dashboard/): need to find the project root's .kanban/
let KANBAN_ROOT = path.resolve(__dirname, '..');
if (!fs.existsSync(path.join(KANBAN_ROOT, 'config.json'))) {
  // Not deployed to .kanban/ -- walk up to find project root with .kanban/
  let searchDir = PROJECT_ROOT;
  for (let i = 0; i < 8; i++) {
    const candidateRoot = path.join(searchDir, '.kanban');
    if (fs.existsSync(path.join(candidateRoot, 'config.json'))) {
      KANBAN_ROOT = candidateRoot;
      break;
    }
    searchDir = path.resolve(searchDir, '..');
  }
  // else: keep default and let endpoints handle missing files gracefully
}

app.use(express.static(__dirname));

// ============================================================
// Input validation
// ============================================================
/**
 * Validate that a task ID parameter is safe to use in file-system operations.
 * Enforces:
 *   - Non-empty string
 *   - Maximum length of 20 characters (prevents buffer overflow / path traversal
 *     via extremely long IDs)
 *   - No ".." sequences (blocks directory traversal attacks e.g. "../", "..\\")
 */
const PATH_TRAVERSAL_PATTERN = /\.\./;
function isValidTaskId(id) {
  return typeof id === 'string' && id.length > 0 && id.length <= 20 && !PATH_TRAVERSAL_PATTERN.test(id);
}

// ============================================================
// Shared helpers
// ============================================================

/**
 * Collect evaluation reports for a task from its iteration directories.
 * Used by /api/tasks/:id, /api/archive/:id, and /api/archived-tasks/:id.
 *
 * @param {string} taskDir - Parent directory containing the task subdirectory (e.g. tasks/ or archive/)
 * @param {string} taskId  - The task ID (e.g. TASK-001)
 * @param {object} data    - The parsed task JSON (may contain a scores object)
 * @returns {Array} Collected report objects
 */
function collectReports(taskDir, taskId, data) {
  const reports = [];

  // 1. Reports referenced in scores object (path in score info)
  if (data.scores) {
    for (const [role, info] of Object.entries(data.scores)) {
      if (typeof info === 'object' && info.report) {
        let reportPath = path.join(KANBAN_ROOT, info.report);
        if (!fs.existsSync(reportPath)) {
          reportPath = info.report; // try as-is (may already be absolute)
        }
        if (fs.existsSync(reportPath)) {
          try {
            const reportData = JSON.parse(fs.readFileSync(reportPath, 'utf-8'));
            reports.push({ role, score: info.score, passed: info.passed, report: reportData });
          } catch (_) { /* skip malformed report */ }
        }
      }
    }
  }

  // 2. Scan iteration directories for report files
  //    <taskDir>/<taskId>/iteration-N/<role>_report.json
  const taskSubdir = path.join(taskDir, taskId);
  if (fs.existsSync(taskSubdir) && fs.statSync(taskSubdir).isDirectory()) {
    const iterEntries = fs.readdirSync(taskSubdir, { withFileTypes: true });
    for (const entry of iterEntries) {
      if (!entry.isDirectory() || !entry.name.startsWith('iteration-')) continue;
      const iterDir = path.join(taskSubdir, entry.name);
      const roleFiles = fs.readdirSync(iterDir).filter(f => f.endsWith('_report.json'));
      for (const rf of roleFiles) {
        const role = rf.replace('_report.json', '');
        // Skip if we already have this role's report from scores
        if (reports.some(r => r.role === role)) continue;
        try {
          const reportData = JSON.parse(fs.readFileSync(path.join(iterDir, rf), 'utf-8'));
          const iteration = parseInt(entry.name.replace('iteration-', ''), 10);
          reports.push({
            role,
            score: reportData.scores ? (reportData.scores.overall || null) : null,
            passed: reportData.passed || false,
            report: reportData,
            iteration
          });
        } catch (_) { /* skip malformed report */ }
      }
    }
  }

  return reports;
}

// ============================================================
// SSE (Server-Sent Events) — real-time push to dashboard
// ============================================================

const sseClients = new Set();

/** Broadcast a named SSE event to every connected client. */
function broadcastSSE(eventType, data) {
  const payload = `event: ${eventType}\ndata: ${JSON.stringify(data)}\n\n`;
  for (const client of sseClients) {
    client.write(payload);
  }
}

/**
 * Debounced event scheduler.
 * If the same *key* fires again within the delay window the previous
 * timer is cancelled and replaced — guarantees at most one broadcast
 * per burst.
 */
const pendingEvents = new Map();
function scheduleEvent(key, delay, fireFn) {
  const existing = pendingEvents.get(key);
  if (existing) clearTimeout(existing.timer);
  pendingEvents.set(key, {
    timer: setTimeout(() => {
      pendingEvents.delete(key);
      fireFn();
    }, delay),
    fireFn
  });
}

// --- Task cache for diff detection ---
let cachedTasks = [];

/**
 * Map role name with underscores to template filename with hyphens.
 * Bug #4 fix: code_reviewer -> code-reviewer for template lookup.
 */
function roleToTemplateFilename(role) {
  return role.replace(/_/g, '-') + '.json';
}

/** Read a single task JSON, trying both new (subdir) and old (flat) layouts. */
function readTaskJson(tasksDir, idOrFile) {
  // Try new layout first: tasks/TASK-NNN/task.json
  const subdirPath = path.join(tasksDir, idOrFile.replace(/\.json$/, ''), 'task.json');
  if (fs.existsSync(subdirPath)) {
    try {
      return JSON.parse(fs.readFileSync(subdirPath, 'utf-8'));
    } catch (_) { return null; }
  }
  // Fallback to old layout: tasks/TASK-NNN.json
  const flatPath = path.join(tasksDir, idOrFile);
  if (fs.existsSync(flatPath) && flatPath.endsWith('.json')) {
    try {
      return JSON.parse(fs.readFileSync(flatPath, 'utf-8'));
    } catch (_) { return null; }
  }
  return null;
}

/** Read every task file under .kanban/tasks/ and return a summary array. */
function readAllTasks() {
  const tasksDir = path.join(KANBAN_ROOT, 'tasks');
  const results = [];

  if (fs.existsSync(tasksDir)) {
    // Scan new layout: tasks/TASK-NNN/task.json (subdirectories)
    const entries = fs.readdirSync(tasksDir, { withFileTypes: true });
    for (const entry of entries) {
      if (!entry.isDirectory()) continue;
      const taskJsonPath = path.join(tasksDir, entry.name, 'task.json');
      if (!fs.existsSync(taskJsonPath)) continue;
      try {
        const data = JSON.parse(fs.readFileSync(taskJsonPath, 'utf-8'));
        results.push({
          id: data.id || entry.name,
          status: data.status,
          phase: data.phase,
          phase_lock: data.phase_lock,
          iteration: data.iteration,
          updated_at: data.updated_at,
          archived: false
        });
      } catch (_) { /* skip malformed */ }
    }

    // Scan old layout: tasks/TASK-NNN.json (flat files)
    const files = fs.readdirSync(tasksDir).filter(f => f.endsWith('.json'));
    for (const f of files) {
      try {
        const data = JSON.parse(fs.readFileSync(path.join(tasksDir, f), 'utf-8'));
        const id = data.id || f.replace('.json', '');
        // Avoid duplicates if both formats exist for same task
        if (!results.some(r => r.id === id)) {
          results.push({
            id,
            status: data.status,
            phase: data.phase,
            phase_lock: data.phase_lock,
            iteration: data.iteration,
            updated_at: data.updated_at,
            archived: false
          });
        }
      } catch (_) { /* skip malformed */ }
    }
  }

  // Also scan archive directory
  const archiveDir = path.join(KANBAN_ROOT, 'archive');
  if (fs.existsSync(archiveDir)) {
    const archiveEntries = fs.readdirSync(archiveDir, { withFileTypes: true });
    for (const entry of archiveEntries) {
      if (!entry.isDirectory()) continue;
      const taskJsonPath = path.join(archiveDir, entry.name, 'task.json');
      if (!fs.existsSync(taskJsonPath)) continue;
      try {
        const data = JSON.parse(fs.readFileSync(taskJsonPath, 'utf-8'));
        results.push({
          id: data.id || entry.name,
          status: data.status,
          phase: data.phase,
          phase_lock: data.phase_lock,
          iteration: data.iteration,
          updated_at: data.updated_at,
          archived: true
        });
      } catch (_) { /* skip malformed */ }
    }

    // Scan old layout: archive/TASK-NNN.json (flat files)
    const archiveFiles = fs.readdirSync(archiveDir).filter(f => f.endsWith('.json'));
    for (const f of archiveFiles) {
      try {
        const data = JSON.parse(fs.readFileSync(path.join(archiveDir, f), 'utf-8'));
        const id = data.id || f.replace('.json', '');
        if (!results.some(r => r.id === id)) {
          results.push({
            id,
            status: data.status,
            phase: data.phase,
            phase_lock: data.phase_lock,
            iteration: data.iteration,
            updated_at: data.updated_at,
            archived: true
          });
        }
      } catch (_) { /* skip malformed */ }
    }
  }

  return results;
}

/**
 * Read a single archived task by ID from .kanban/archive/.
 * Tries both new layout (archive/TASK-NNN/task.json) and old layout (archive/TASK-NNN.json).
 *
 * @param {string} taskId - The task ID (e.g. TASK-001)
 * @returns {object|null} Parsed task JSON or null if not found
 */
function readArchivedTask(taskId) {
  const archiveDir = path.join(KANBAN_ROOT, 'archive');

  // Try new layout first: archive/TASK-NNN/task.json
  const subdirPath = path.join(archiveDir, taskId, 'task.json');
  if (fs.existsSync(subdirPath)) {
    try {
      return JSON.parse(fs.readFileSync(subdirPath, 'utf-8'));
    } catch (_) { /* malformed */ }
  }

  // Fallback to old layout: archive/TASK-NNN.json
  const flatPath = path.join(archiveDir, `${taskId}.json`);
  if (fs.existsSync(flatPath)) {
    try {
      return JSON.parse(fs.readFileSync(flatPath, 'utf-8'));
    } catch (_) { /* malformed */ }
  }

  return null;
}

/** Read all archived tasks from .kanban/archive/ directory. */
function readArchivedTasks() {
  const archiveDir = path.join(KANBAN_ROOT, 'archive');
  if (!fs.existsSync(archiveDir)) return [];

  const results = [];
  const entries = fs.readdirSync(archiveDir, { withFileTypes: true });

  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    // Try new layout: archive/TASK-NNN/task.json
    const taskJsonPath = path.join(archiveDir, entry.name, 'task.json');
    if (fs.existsSync(taskJsonPath)) {
      try {
        const data = JSON.parse(fs.readFileSync(taskJsonPath, 'utf-8'));
        results.push({
          id: data.id || entry.name,
          title: data.title,
          description: data.description,
          status: data.status,
          phase: data.phase,
          iteration: data.iteration,
          scores: data.scores,
          created_at: data.created_at,
          updated_at: data.updated_at
        });
      } catch (_) { /* skip malformed */ }
    }
  }

  // Also scan old layout: archive/TASK-NNN.json (flat files)
  const files = fs.readdirSync(archiveDir).filter(f => f.endsWith('.json'));
  for (const f of files) {
    try {
      const data = JSON.parse(fs.readFileSync(path.join(archiveDir, f), 'utf-8'));
      const id = data.id || f.replace('.json', '');
      if (!results.some(r => r.id === id)) {
        results.push({
          id,
          title: data.title,
          description: data.description,
          status: data.status,
          phase: data.phase,
          iteration: data.iteration,
          scores: data.scores,
          created_at: data.created_at,
          updated_at: data.updated_at
        });
      }
    } catch (_) { /* skip malformed */ }
  }

  return results;
}

/** Compare cached and current task lists, emit granular events. */
function diffAndBroadcastTasks() {
  const current = readAllTasks();
  const cachedMap = new Map(cachedTasks.map(t => [t.id, t]));
  const currentMap = new Map(current.map(t => [t.id, t]));

  const created = [];
  const updated = [];
  const removed = [];

  // Detect created & updated
  for (const task of current) {
    const prev = cachedMap.get(task.id);
    if (!prev) {
      created.push(task);
    } else if (
      prev.status !== task.status ||
      prev.phase !== task.phase ||
      prev.phase_lock !== task.phase_lock ||
      prev.iteration !== task.iteration ||
      prev.updated_at !== task.updated_at ||
      prev.archived !== task.archived
    ) {
      updated.push(task);
    }
  }
  // Detect removed
  for (const task of cachedTasks) {
    if (!currentMap.has(task.id)) {
      removed.push(task);
    }
  }

  // Emit granular per-task events for each change type
  for (const task of created) {
    broadcastSSE('task_created', { id: task.id, task });
  }
  for (const task of updated) {
    broadcastSSE('task_updated', { id: task.id, task });
  }
  for (const task of removed) {
    broadcastSSE('task_removed', { id: task.id, task });
  }

  // Also emit the full refresh event with the complete updated list
  if (created.length > 0 || updated.length > 0 || removed.length > 0) {
    broadcastSSE('tasks:refresh', current);
  }

  cachedTasks = current;
}

// ============================================================
// SSE endpoint
// ============================================================
app.get('/api/events', (req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
    'X-Accel-Buffering': 'no'
  });

  // Send an initial connected event so the client knows it is live.
  res.write(`event: connected\ndata: ${JSON.stringify({ time: Date.now() })}\n\n`);

  sseClients.add(res);

  // Heartbeat every 30 seconds to keep the connection alive through proxies.
  const heartbeat = setInterval(() => {
    res.write(': heartbeat\n\n');
  }, 30000);

  req.on('close', () => {
    clearInterval(heartbeat);
    sseClients.delete(res);
  });
});

// ============================================================
// File watchers (started alongside the server)
// ============================================================
const watchers = [];

/**
 * Set up a recursive watcher on a directory. If the directory does not exist,
 * create it so the watcher can be established. Returns the watcher or null.
 */
function watchDirectory(dir, options, callback) {
  if (!fs.existsSync(dir)) {
    try {
      fs.mkdirSync(dir, { recursive: true });
    } catch (err) {
      console.error(`[watcher] Failed to create directory ${dir}:`, err.message);
      return null;
    }
  }
  try {
    const w = fs.watch(dir, options, callback);
    w.on('error', (err) => {
      console.error(`[watcher] ${path.basename(dir)}/ watcher error:`, err.message);
    });
    watchers.push(w);
    return w;
  } catch (err) {
    console.error(`[watcher] Failed to watch ${dir}:`, err.message);
    return null;
  }
}

function setupWatchers() {
  // Initialise the task cache so the first watch callback can diff.
  cachedTasks = readAllTasks();

  // 1. Watch .kanban/tasks/ directory (including subdirectories for new layout)
  const tasksDir = path.join(KANBAN_ROOT, 'tasks');
  watchDirectory(tasksDir, { recursive: true }, (eventType, filename) => {
    if (!filename) return;
    // Watch for both flat .json files and task.json in subdirectories
    if (filename.endsWith('.json')) {
      scheduleEvent('tasks-dir', 150, () => {
        diffAndBroadcastTasks();
      });
    }
  });

  // 2. Watch .kanban/archive/ directory (for archived task changes)
  const archiveDir = path.join(KANBAN_ROOT, 'archive');
  watchDirectory(archiveDir, { recursive: true }, (eventType, filename) => {
    if (!filename) return;
    if (filename.endsWith('.json')) {
      scheduleEvent('archive-dir', 150, () => {
        diffAndBroadcastTasks();
        broadcastSSE('archive:changed', { filename });
      });
    }
  });

  // 3. Watch .kanban/reports/ (recursive -- legacy path for older layout)
  const reportsDir = path.join(KANBAN_ROOT, 'reports');
  if (fs.existsSync(reportsDir)) {
    watchDirectory(reportsDir, { recursive: true }, (eventType, filename) => {
      if (!filename) return;
      scheduleEvent('reports-dir', 150, () => {
        broadcastSSE('reports:changed', { filename });
      });
    });
  }

  // 4. Watch config.json
  const configPath = path.join(KANBAN_ROOT, 'config.json');
  if (fs.existsSync(configPath)) {
    try {
      const w = fs.watch(configPath, () => {
        try {
          const data = JSON.parse(fs.readFileSync(configPath, 'utf-8'));
          broadcastSSE('config:changed', { file: 'config.json', data });
        } catch (_) { /* ignore read errors during mid-write */ }
      });
      w.on('error', (err) => {
        console.error('[watcher] config.json watcher error:', err.message);
      });
      watchers.push(w);
    } catch (err) {
      console.error('[watcher] Failed to watch config.json:', err.message);
    }
  }

  // 5. Watch workflow.json
  const workflowPath = path.join(KANBAN_ROOT, 'workflow.json');
  if (fs.existsSync(workflowPath)) {
    try {
      const w = fs.watch(workflowPath, () => {
        try {
          const data = JSON.parse(fs.readFileSync(workflowPath, 'utf-8'));
          broadcastSSE('config:changed', { file: 'workflow.json', data });
        } catch (_) { /* ignore read errors during mid-write */ }
      });
      w.on('error', (err) => {
        console.error('[watcher] workflow.json watcher error:', err.message);
      });
      watchers.push(w);
    } catch (err) {
      console.error('[watcher] Failed to watch workflow.json:', err.message);
    }
  }
}

// ============================================================
// Graceful shutdown
// ============================================================
function shutdown(signal) {
  console.log(`\nReceived ${signal}, shutting down gracefully...`);

  // Close all SSE client connections
  for (const client of sseClients) {
    client.end();
  }
  sseClients.clear();

  // Close file watchers
  for (const w of watchers) {
    w.close();
  }

  process.exit(0);
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

// ============================================================
// REST API endpoints (original, unchanged)
// ============================================================

// --- API: read config.json ---
app.get('/api/config', (req, res) => {
  try {
    const configPath = path.join(KANBAN_ROOT, 'config.json');
    const data = JSON.parse(fs.readFileSync(configPath, 'utf-8'));
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: 'Failed to read config.json' });
  }
});

// --- API: read workflow.json ---
app.get('/api/workflow', (req, res) => {
  try {
    const workflowPath = path.join(KANBAN_ROOT, 'workflow.json');
    const data = JSON.parse(fs.readFileSync(workflowPath, 'utf-8'));
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: 'Failed to read workflow.json' });
  }
});

// --- API: list all tasks ---
app.get('/api/tasks', (req, res) => {
  try {
    const tasksDir = path.join(KANBAN_ROOT, 'tasks');
    if (!fs.existsSync(tasksDir)) {
      return res.json([]);
    }

    const tasks = [];

    // Scan new layout: tasks/TASK-NNN/task.json (subdirectories)
    const entries = fs.readdirSync(tasksDir, { withFileTypes: true });
    for (const entry of entries) {
      if (!entry.isDirectory()) continue;
      const taskJsonPath = path.join(tasksDir, entry.name, 'task.json');
      if (!fs.existsSync(taskJsonPath)) continue;
      try {
        const data = JSON.parse(fs.readFileSync(taskJsonPath, 'utf-8'));
        tasks.push({
          id: data.id || entry.name,
          title: data.title,
          description: data.description,
          status: data.status,
          phase: data.phase,
          iteration: data.iteration,
          scores: data.scores,
          assignee: data.assignee,
          created_at: data.created_at,
          updated_at: data.updated_at
        });
      } catch (_) { /* skip malformed */ }
    }

    // Scan old layout: tasks/TASK-NNN.json (flat files)
    const files = fs.readdirSync(tasksDir).filter(f => f.endsWith('.json'));
    for (const f of files) {
      try {
        const data = JSON.parse(fs.readFileSync(path.join(tasksDir, f), 'utf-8'));
        const id = data.id || f.replace('.json', '');
        // Avoid duplicates if both formats exist for same task
        if (!tasks.some(t => t.id === id)) {
          tasks.push({
            id,
            title: data.title,
            description: data.description,
            status: data.status,
            phase: data.phase,
            iteration: data.iteration,
            scores: data.scores,
            assignee: data.assignee,
            created_at: data.created_at,
            updated_at: data.updated_at
          });
        }
      } catch (_) { /* skip malformed */ }
    }

    res.json(tasks);
  } catch (err) {
    res.status(500).json({ error: 'Failed to read tasks' });
  }
});

// --- API: single task detail ---
app.get('/api/tasks/:id', (req, res) => {
  try {
    const taskId = req.params.id;
    if (!isValidTaskId(taskId)) {
      return res.status(400).json({ error: 'Invalid task ID format' });
    }
    const tasksDir = path.join(KANBAN_ROOT, 'tasks');
    const data = readTaskJson(tasksDir, `${taskId}.json`);
    if (!data) {
      return res.status(404).json({ error: 'Task not found' });
    }
    if (!data.id) data.id = taskId;

    const reports = collectReports(tasksDir, taskId, data);

    res.json({ ...data, reports });
  } catch (err) {
    res.status(500).json({ error: 'Failed to read task' });
  }
});

// --- API: list archived tasks (read-only) ---
app.get('/api/archive', (req, res) => {
  try {
    res.json(readArchivedTasks());
  } catch (err) {
    res.status(500).json({ error: 'Failed to read archived tasks' });
  }
});

// --- API: single archived task detail ---
app.get('/api/archive/:id', (req, res) => {
  try {
    const taskId = req.params.id;
    if (!isValidTaskId(taskId)) {
      return res.status(400).json({ error: 'Invalid task ID format' });
    }

    const data = readArchivedTask(taskId);
    if (!data) {
      return res.status(404).json({ error: 'Archived task not found' });
    }
    if (!data.id) data.id = taskId;

    const archiveDir = path.join(KANBAN_ROOT, 'archive');
    const reports = collectReports(archiveDir, taskId, data);

    res.json({ ...data, reports });
  } catch (err) {
    res.status(500).json({ error: 'Failed to read archived task' });
  }
});

// --- API: list all archived tasks (summary format, same as /api/tasks) ---
app.get('/api/archived-tasks', (req, res) => {
  try {
    res.json(readArchivedTasks());
  } catch (err) {
    res.status(500).json({ error: 'Failed to read archived tasks' });
  }
});

// --- API: single archived task detail (same format as /api/tasks/:id) ---
app.get('/api/archived-tasks/:id', (req, res) => {
  try {
    const taskId = req.params.id;
    if (!isValidTaskId(taskId)) {
      return res.status(400).json({ error: 'Invalid task ID format' });
    }

    const data = readArchivedTask(taskId);
    if (!data) {
      return res.status(404).json({ error: 'Archived task not found' });
    }
    if (!data.id) data.id = taskId;

    const archiveDir = path.join(KANBAN_ROOT, 'archive');
    const reports = collectReports(archiveDir, taskId, data);

    res.json({ ...data, reports });
  } catch (err) {
    res.status(500).json({ error: 'Failed to read archived task' });
  }
});

/**
 * Read the latest retrospective.md for a given task from its parent directory.
 * Scans iteration-N/ subdirectories and returns the content of the latest one found.
 *
 * @param {string} parentDir - Parent directory containing the task subdirectory (e.g. tasks/ or archive/)
 * @param {string} taskId    - The task ID (e.g. TASK-001)
 * @returns {{ iteration: number, content: string }|null} Latest retrospective or null
 */
function readRetrospective(parentDir, taskId) {
  const taskSubdir = path.join(parentDir, taskId);
  if (!fs.existsSync(taskSubdir)) {
    return null;
  }

  // Find the latest iteration with a retrospective.md
  const iterEntries = fs.readdirSync(taskSubdir, { withFileTypes: true });
  let latestRetrospective = null;
  let latestIter = 0;

  for (const entry of iterEntries) {
    if (!entry.isDirectory() || !entry.name.startsWith('iteration-')) continue;
    const retroPath = path.join(taskSubdir, entry.name, 'retrospective.md');
    if (fs.existsSync(retroPath)) {
      const iterNum = parseInt(entry.name.replace('iteration-', ''), 10);
      if (iterNum > latestIter) {
        latestIter = iterNum;
        latestRetrospective = fs.readFileSync(retroPath, 'utf-8');
      }
    }
  }

  if (!latestRetrospective) {
    return null;
  }

  return { iteration: latestIter, content: latestRetrospective };
}

// --- API: retrospective for an archived task ---
app.get('/api/archived-tasks/:id/retrospective', (req, res) => {
  try {
    const taskId = req.params.id;
    if (!isValidTaskId(taskId)) {
      return res.status(400).json({ error: 'Invalid task ID format' });
    }

    const archiveDir = path.join(KANBAN_ROOT, 'archive');
    const result = readRetrospective(archiveDir, taskId);
    if (!result) {
      return res.status(404).json({ error: 'No retrospective found for this task' });
    }

    res.json({
      task_id: taskId,
      iteration: result.iteration,
      content: result.content
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to read retrospective' });
  }
});

// --- API: retrospective for an active task ---
app.get('/api/tasks/:id/retrospective', (req, res) => {
  try {
    const taskId = req.params.id;
    if (!isValidTaskId(taskId)) {
      return res.status(400).json({ error: 'Invalid task ID format' });
    }

    const tasksDir = path.join(KANBAN_ROOT, 'tasks');
    const result = readRetrospective(tasksDir, taskId);
    if (!result) {
      return res.status(404).json({ error: 'No retrospective found for this task' });
    }

    res.json({
      task_id: taskId,
      iteration: result.iteration,
      content: result.content
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to read retrospective' });
  }
});

// ============================================================
// Start server
// ============================================================
app.listen(PORT, () => {
  setupWatchers();
  console.log(`Dashboard running at http://localhost:${PORT}`);
  console.log(`SSE endpoint available at http://localhost:${PORT}/api/events`);
});
