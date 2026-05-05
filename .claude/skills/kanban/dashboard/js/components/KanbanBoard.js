// dashboard/js/components/KanbanBoard.js
import { ref, computed, onMounted, watch, nextTick } from 'https://unpkg.com/vue@3/dist/vue.esm-browser.js';
import { api } from '../utils/api.js';
import { useSearchFilter } from '../composables/useSearchFilter.js';
import { useReportViewer } from '../composables/useReportViewer.js';
import { useTaskDetail } from '../composables/useTaskDetail.js';
import { useRealtime } from '../composables/useRealtime.js';
import { useScoreChart } from '../composables/useScoreChart.js';
import { StatsOverview } from './StatsOverview.js';

export const KanbanBoard = {
  components: {
    StatsOverview
  },
  setup() {
    const { tasks, connectionStatus, archivedTasks } = useRealtime();
    const loading = ref(true);

    const columns = [
      { key: 'plan', label: '\u{23F3} PLAN', cssClass: 'column-plan' },
      { key: 'execute', label: '\u{1F528} EXECUTE', cssClass: 'column-execute' },
      { key: 'evaluate', label: '\u{1F50D} EVALUATE', cssClass: 'column-evaluate' },
      { key: 'archive', label: '\u{2705} ARCHIVE', cssClass: 'column-archive' },
    ];

    // Composables (order matters: taskDetail must exist before report viewer)
    const {
      searchQuery, selectedPhases, filterMenuOpen, filteredTasks,
      restoreFilterFromURL, togglePhase, toggleFilterMenu, closeFilterMenu
    } = useSearchFilter(tasks);

    const {
      selectedTask, taskDetail, openDetail, closeDetail
    } = useTaskDetail();

    const {
      selectedIteration, expandedReports, iterationReports,
      currentIterationReports, toggleReport, isReportExpanded,
      scoreClass, getDimensions
    } = useReportViewer(taskDetail);

    // Score trend chart composable
    const { chartCanvas, renderChart, destroyChart } = useScoreChart();

    // Whether the task has enough iteration data to show the chart
    const showScoreChart = computed(() => {
      if (!taskDetail.value || !taskDetail.value.reports) return false;
      const reports = taskDetail.value.reports;
      if (reports.length === 0) return false;
      // Need at least 2 distinct iterations with report data
      const iterations = new Set(reports.map(r => r.iteration || 1));
      return iterations.size >= 2;
    });

    // Watch taskDetail to render chart when reports are available
    watch(taskDetail, async (detail) => {
      if (detail && detail.reports && detail.reports.length > 0) {
        await nextTick();
        renderChart(detail.reports);
      } else {
        destroyChart();
      }
    });

    // Wrap openDetail to also reset iteration
    const handleOpenDetail = async (task) => {
      await openDetail(task);
      selectedIteration.value = 0;
    };

    // Render description as Markdown with DOMPurify sanitization
    const renderedDescription = computed(() => {
      if (!taskDetail.value || !taskDetail.value.description) return '';
      const rawHtml = window.marked.parse(taskDetail.value.description);
      return window.DOMPurify.sanitize(rawHtml);
    });

    const phaseMap = {
      plan: 'plan', planning: 'plan', pending: 'plan',
      execute: 'execute',
      evaluate: 'evaluate', evaluating: 'evaluate', user_decision: 'evaluate',
      archive: 'archive', archived: 'archive',
    };

    const getTasksForPhase = (phase) => {
      return filteredTasks.value.filter(t => {
        // Archived tasks (with archived flag) always go to the archive column,
        // regardless of their phase value, unless their phase already maps there.
        if (phase === 'archive' && t.archived === true) return true;
        if (phase !== 'archive' && t.archived === true) return false;
        return (phaseMap[t.phase] || 'plan') === phase;
      });
    };

    const avgScore = (scores) => {
      if (!scores) return null;
      const values = Object.values(scores).map(s => typeof s === 'object' ? s.score : s);
      return (values.reduce((a, b) => a + b, 0) / values.length).toFixed(2);
    };

    // Extract numeric score value from a score entry (may be number or {score, ...} object)
    const getScoreValue = (info) => typeof info === 'object' ? info.score : info;

    const formatPhase = (phase) => {
      const map = { plan: 'Planning', execute: 'In Progress', evaluate: 'Evaluating', archive: 'Done' };
      return map[phase] || phase;
    };

    // History timeline helpers
    const phaseIcons = {
      plan: '\u{23F3}',
      execute: '\u{1F528}',
      evaluate: '\u{1F50D}',
      archive: '\u{2705}',
      user_decision: '\u{1F4CB}',
      self_improve: '\u{1F504}',
      archived: '\u{2705}',
      planning: '\u{23F3}',
      evaluating: '\u{1F50D}',
      pending: '\u{23F3}',
    };

    const getPhaseIcon = (phase) => phaseIcons[phase] || '\u{1F4CB}';

    const formatHistoryPhase = (phase) => {
      const map = {
        plan: 'Plan',
        planning: 'Planning',
        pending: 'Pending',
        execute: 'Execute',
        evaluate: 'Evaluate',
        evaluating: 'Evaluating',
        user_decision: 'User Decision',
        self_improve: 'Self Improve',
        archive: 'Archive',
        archived: 'Archived',
      };
      return map[phase] || phase;
    };

    const formatHistoryStatus = (h) => {
      if (h.status === 'completed') return 'Completed';
      if (h.status === 'entered') return 'In Progress';
      if (h.type === 'full') return 'Full Iteration';
      if (h.type === 'hot') return 'Hot Iteration';
      return h.status || h.type || '';
    };

    const formatTimestamp = (ts) => {
      if (!ts) return '';
      try {
        const d = new Date(ts);
        const month = d.toLocaleString('en-US', { month: 'short' });
        const day = d.getDate();
        const year = d.getFullYear();
        const hours = String(d.getHours()).padStart(2, '0');
        const minutes = String(d.getMinutes()).padStart(2, '0');
        return `${month} ${day}, ${year}, ${hours}:${minutes}`;
      } catch {
        return ts;
      }
    };

    const getHistoryTimestamp = (h) => {
      return h.exited_at || h.entered_at || '';
    };

    const phaseColorClass = (phase) => {
      const map = {
        plan: 'timeline-phase-plan',
        planning: 'timeline-phase-plan',
        pending: 'timeline-phase-plan',
        execute: 'timeline-phase-execute',
        evaluate: 'timeline-phase-evaluate',
        evaluating: 'timeline-phase-evaluate',
        user_decision: 'timeline-phase-evaluate',
        self_improve: 'timeline-phase-self-improve',
        archive: 'timeline-phase-archive',
        archived: 'timeline-phase-archive',
      };
      return map[phase] || '';
    };

    onMounted(async () => {
      restoreFilterFromURL();
      // fetchInitialData + connect already called by app.js on startup
      // Just wait for tasks to be populated
      loading.value = false;
    });

    return {
      tasks, archivedTasks, loading, columns, selectedTask, taskDetail,
      getTasksForPhase, avgScore, getScoreValue, openDetail: handleOpenDetail, closeDetail, formatPhase,
      renderedDescription,
      searchQuery, selectedPhases, filteredTasks,
      togglePhase, filterMenuOpen, toggleFilterMenu, closeFilterMenu,
      selectedIteration, iterationReports, currentIterationReports,
      scoreClass, getDimensions, expandedReports, toggleReport, isReportExpanded,
      connectionStatus,
      // Score trend chart
      chartCanvas, showScoreChart,
      // History timeline helpers
      getPhaseIcon, formatHistoryPhase, formatHistoryStatus,
      formatTimestamp, getHistoryTimestamp, phaseColorClass
    };
  },
  template: `
    <div v-if="loading" class="loading">Loading tasks...</div>
    <div v-else>
      <!-- Search and Filter Toolbar -->
      <div class="board-toolbar">
        <input class="search-input" type="text" v-model="searchQuery" placeholder="Search by ID or title..." />
        <div class="filter-dropdown">
          <button class="filter-btn" @click="toggleFilterMenu">
            Filter: {{ selectedPhases.length }}/4 phases
          </button>
          <div v-if="filterMenuOpen" class="filter-menu">
            <label v-for="col in columns" :key="col.key">
              <input type="checkbox" :checked="selectedPhases.includes(col.key)" @change="togglePhase(col.key)" />
              {{ col.label }}
            </label>
          </div>
        </div>
        <span class="connection-status" :class="connectionStatus">
          {{ connectionStatus === 'connected' ? 'Live' : connectionStatus === 'error' ? 'Reconnecting...' : 'Offline' }}
        </span>
      </div>

      <!-- Statistics Overview Cards -->
      <stats-overview :tasks="tasks"></stats-overview>

      <div class="kanban-columns" @click="closeFilterMenu">
        <div v-for="col in columns" :key="col.key"
             class="kanban-column" :class="col.cssClass">
          <div class="column-header">
            <span>{{ col.label }}</span>
            <span class="column-count">{{ getTasksForPhase(col.key).length }}</span>
          </div>
          <div v-for="task in getTasksForPhase(col.key)" :key="task.id"
               class="task-card" @click="openDetail(task)">
            <div class="task-id">{{ task.id }}</div>
            <div class="task-title">{{ task.title }}</div>
            <div class="task-meta">
              <span class="task-badge" :class="'badge-' + task.phase">
                {{ formatPhase(task.phase) }}
                <template v-if="task.phase === 'archive' && avgScore(task.scores)">
                  · {{ avgScore(task.scores) }}
                </template>
              </span>
              <div class="task-avatar">\u{1F916}</div>
            </div>
          </div>
          <div v-if="getTasksForPhase(col.key).length === 0" class="empty-state">
            No tasks
          </div>
        </div>

        <!-- Task Detail Panel -->
        <div v-if="taskDetail" class="task-detail-overlay">
          <button class="close-btn" @click="closeDetail">&times;</button>
          <h2>{{ taskDetail.id }} {{ taskDetail.title }}</h2>
          <div class="markdown-body" style="font-size:0.85rem; margin-bottom:1rem;" v-html="renderedDescription"></div>

          <div class="detail-section" v-if="taskDetail.scores && Object.keys(taskDetail.scores).length">
            <h4>Scores</h4>
            <div class="score-bars">
              <div v-for="(info, role) in taskDetail.scores" :key="role" class="score-bar-row">
                <span class="score-bar-role">{{ role }}</span>
                <div class="score-bar-track">
                  <div class="score-bar-fill" :class="scoreClass(getScoreValue(info))" :style="{ width: (getScoreValue(info) * 10) + '%' }"></div>
                </div>
                <span class="score-bar-value">{{ getScoreValue(info) }}</span>
              </div>
            </div>
          </div>

          <div class="detail-section">
            <h4>History</h4>
            <div v-if="taskDetail.history && taskDetail.history.length" class="history-timeline">
              <div v-for="(h, i) in taskDetail.history" :key="i"
                   class="timeline-entry"
                   :class="[phaseColorClass(h.phase), { 'timeline-entry-latest': i === taskDetail.history.length - 1 }]">
                <div class="timeline-dot-wrapper">
                  <span class="timeline-dot"></span>
                  <span v-if="i < taskDetail.history.length - 1" class="timeline-line"></span>
                </div>
                <div class="timeline-content">
                  <div class="timeline-header">
                    <span class="timeline-icon">{{ getPhaseIcon(h.phase) }}</span>
                    <span class="timeline-phase-name">{{ formatHistoryPhase(h.phase) }}</span>
                    <span v-if="h.iteration" class="timeline-iteration">Iter {{ h.iteration }}</span>
                    <span class="timeline-status" :class="'status-' + (h.status || 'default')">{{ formatHistoryStatus(h) }}</span>
                  </div>
                  <div v-if="getHistoryTimestamp(h)" class="timeline-timestamp">
                    {{ formatTimestamp(getHistoryTimestamp(h)) }}
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="timeline-empty">No history recorded</div>
          </div>

          <!-- Score Trend Chart -->
          <div class="detail-section" v-if="showScoreChart">
            <h4>Score Trend</h4>
            <div class="score-chart-container">
              <canvas ref="chartCanvas"></canvas>
            </div>
          </div>

          <!-- Structured Evaluation Reports -->
          <div class="detail-section" v-if="currentIterationReports.length">
            <h4>Evaluation Reports</h4>
            <!-- Iteration tabs -->
            <div class="iteration-tabs" v-if="iterationReports.length > 1">
              <button v-for="(iterGroup, idx) in iterationReports" :key="idx"
                      class="iteration-tab" :class="{ active: selectedIteration === idx }"
                      @click="selectedIteration = idx">
                Iter {{ iterGroup.iteration }}
              </button>
            </div>

            <div v-for="r in currentIterationReports" :key="r.role" class="eval-report-card">
              <div class="eval-report-header" @click="toggleReport(r.role)">
                <div class="eval-report-header-left">
                  <span class="eval-expand-icon" :class="{ collapsed: !isReportExpanded(r.role) }">\u{25BC}</span>
                  <span class="eval-role-name">{{ r.role }}</span>
                  <span class="eval-score-badge" :class="scoreClass(r.score)">{{ r.score }}</span>
                </div>
                <span class="eval-pass-fail" :class="r.passed ? 'eval-pass' : 'eval-fail'">
                  {{ r.passed ? 'PASS' : 'FAIL' }}
                </span>
              </div>

              <div v-if="isReportExpanded(r.role)" class="eval-report-body">
                <div class="eval-dimensions">
                  <div v-for="dim in getDimensions(r.report)" :key="dim.name" class="eval-dimension-row">
                    <span class="eval-dim-name" :title="dim.name">{{ dim.name }}</span>
                    <div class="eval-dim-bar-bg">
                      <div class="eval-dim-bar" :class="scoreClass(dim.score)" :style="{ width: (dim.score * 10) + '%' }"></div>
                    </div>
                    <span class="eval-dim-value">{{ dim.score }}</span>
                  </div>
                </div>

                <div v-for="dim in getDimensions(r.report)" :key="'fi-' + dim.name" class="eval-findings-issues">
                  <template v-if="dim.findings.length">
                    <div class="eval-list-title">Findings ({{ dim.name }})</div>
                    <div v-for="(f, fi) in dim.findings" :key="'f' + fi" class="eval-list-item">
                      <span class="eval-list-icon finding">\u{2713}</span>
                      <span>{{ typeof f === 'string' ? f : f.message || f.text || JSON.stringify(f) }}</span>
                    </div>
                  </template>
                  <template v-if="dim.issues.length">
                    <div class="eval-list-title">Issues ({{ dim.name }})</div>
                    <div v-for="(issue, ii) in dim.issues" :key="'i' + ii" class="eval-list-item">
                      <span class="eval-list-icon issue">\u{26A0}</span>
                      <span>{{ typeof issue === 'string' ? issue : issue.message || issue.text || JSON.stringify(issue) }}</span>
                    </div>
                  </template>
                </div>

                <!-- If no structured dimensions found, show raw findings/issues from report root -->
                <div v-if="getDimensions(r.report).length === 0" class="eval-findings-issues">
                  <template v-if="r.report && r.report.findings && r.report.findings.length">
                    <div class="eval-list-title">Findings</div>
                    <div v-for="(f, fi) in r.report.findings" :key="'rf' + fi" class="eval-list-item">
                      <span class="eval-list-icon finding">\u{2713}</span>
                      <span>{{ typeof f === 'string' ? f : f.message || f.text || JSON.stringify(f) }}</span>
                    </div>
                  </template>
                  <template v-if="r.report && r.report.issues && r.report.issues.length">
                    <div class="eval-list-title">Issues</div>
                    <div v-for="(issue, ii) in r.report.issues" :key="'ri' + ii" class="eval-list-item">
                      <span class="eval-list-icon issue">\u{26A0}</span>
                      <span>{{ typeof issue === 'string' ? issue : issue.message || issue.text || JSON.stringify(issue) }}</span>
                    </div>
                  </template>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  `
};
