// dashboard/js/components/StatsOverview.js
import { computed } from 'vue';

export const StatsOverview = {
  props: {
    tasks: { type: Array, default: () => [] }
  },
  setup(props) {
    const total = computed(() => props.tasks.length);
    const byPhase = computed(() => {
      const counts = {};
      for (const t of props.tasks) {
        const p = t.phase || 'plan';
        counts[p] = (counts[p] || 0) + 1;
      }
      return counts;
    });
    const avgScore = computed(() => {
      const withScores = props.tasks.filter(t => t.scores);
      if (withScores.length === 0) return null;
      let sum = 0;
      let count = 0;
      for (const t of withScores) {
        for (const v of Object.values(t.scores)) {
          sum += typeof v === 'object' ? v.score : v;
          count++;
        }
      }
      return count > 0 ? (sum / count).toFixed(1) : null;
    });

    return { total, byPhase, avgScore };
  },
  template: `
    <div class="stats-overview">
      <div class="stat-card">
        <span class="stat-label">Total Tasks</span>
        <span class="stat-value">{{ total }}</span>
      </div>
      <div class="stat-card">
        <span class="stat-label">Plan</span>
        <span class="stat-value">{{ byPhase.plan || 0 }}</span>
      </div>
      <div class="stat-card">
        <span class="stat-label">Execute</span>
        <span class="stat-value">{{ byPhase.execute || 0 }}</span>
      </div>
      <div class="stat-card">
        <span class="stat-label">Evaluate</span>
        <span class="stat-value">{{ byPhase.evaluate || 0 }}</span>
      </div>
      <div class="stat-card" v-if="avgScore !== null">
        <span class="stat-label">Avg Score</span>
        <span class="stat-value">{{ avgScore }}</span>
      </div>
    </div>
  `
};
