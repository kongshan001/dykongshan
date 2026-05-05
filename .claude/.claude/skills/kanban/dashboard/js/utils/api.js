// dashboard/js/utils/api.js
const API_BASE = '/api';

async function fetchJSON(url) {
  const res = await fetch(API_BASE + url);
  if (!res.ok) {
    throw new Error(`API error: ${res.status} ${res.statusText}`);
  }
  return res.json();
}

export const api = {
  getConfig: () => fetchJSON('/config'),
  getWorkflow: () => fetchJSON('/workflow'),
  getTasks: () => fetchJSON('/tasks'),
  getTask: (id) => fetchJSON(`/tasks/${id}`),
  getArchivedTasks: () => fetchJSON('/archived-tasks'),
  getArchivedTask: (id) => fetchJSON(`/archived-tasks/${id}`),
  getRetrospective: (id, archived) => fetchJSON(`/${archived ? 'archived-tasks' : 'tasks'}/${id}/retrospective`),
};
