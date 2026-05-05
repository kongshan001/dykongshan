// dashboard/js/composables/useTaskDetail.js
import { ref } from 'https://unpkg.com/vue@3/dist/vue.esm-browser.js';
import { api } from '../utils/api.js';
import { useRealtime } from './useRealtime.js';

export function useTaskDetail() {
  const selectedTask = ref(null);
  const taskDetail = ref(null);
  const selectedTaskIsArchived = ref(false);
  const retrospectiveContent = ref(null);
  const { onTaskUpdate } = useRealtime();

  let unsubTaskUpdate = null;

  /**
   * Determine whether a task object represents an archived task.
   * Checks both the `archived` flag (set by useRealtime) and the `phase` field.
   */
  const isArchivedTask = (task) => task.archived === true || task.phase === 'archive' || task.phase === 'archived';

  /**
   * Fetch task detail using the appropriate API endpoint.
   * Archived tasks use /api/archived-tasks/:id, active tasks use /api/tasks/:id.
   */
  const fetchDetail = (id, archived) => {
    return archived ? api.getArchivedTask(id) : api.getTask(id);
  };

  const openDetail = async (task) => {
    try {
      const archived = isArchivedTask(task);
      taskDetail.value = await fetchDetail(task.id, archived);
      selectedTask.value = task.id;
      selectedTaskIsArchived.value = archived;

      // Fetch retrospective if available
      retrospectiveContent.value = null;
      try {
        const retro = await api.getRetrospective(task.id, archived);
        retrospectiveContent.value = retro.content || null;
      } catch (_) {
        // No retrospective available, that's fine
        retrospectiveContent.value = null;
      }

      // Clean up old listener
      if (unsubTaskUpdate) unsubTaskUpdate();

      // Listen for task updates, auto-refresh detail
      unsubTaskUpdate = onTaskUpdate((update) => {
        // update has a type field: 'task_created', 'task_updated', 'task_archived',
        // 'tasks:refresh', or 'reports:changed'
        const shouldRefresh =
          update.__reportsChanged ||
          update.type === 'task_updated' ||
          update.type === 'task_created' ||
          update.type === 'task_archived' ||
          (update.type === 'tasks:refresh' && Array.isArray(update.data) && update.data.some(t => t.id === selectedTask.value));
        if (shouldRefresh) {
          fetchDetail(selectedTask.value, selectedTaskIsArchived.value).then(d => { taskDetail.value = d; }).catch(() => {});
        }
      });
    } catch (e) {
      console.error('Failed to load task detail', e);
    }
  };

  const closeDetail = () => {
    selectedTask.value = null;
    taskDetail.value = null;
    selectedTaskIsArchived.value = false;
    retrospectiveContent.value = null;
    if (unsubTaskUpdate) { unsubTaskUpdate(); unsubTaskUpdate = null; }
  };

  return { selectedTask, taskDetail, retrospectiveContent, openDetail, closeDetail };
}
