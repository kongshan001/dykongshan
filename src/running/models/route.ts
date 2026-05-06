/**
 * 跑步路线数据模型
 */

export type Difficulty = 'beginner' | 'intermediate' | 'advanced';
export type SurfaceType = 'paved' | 'trail' | 'mixed' | 'track';
export type SceneryType = 'waterfront' | 'park' | 'urban' | 'mountain' | 'historic';

export interface RunningRoute {
  id: string;
  name: string;
  nameLocal: string;
  city: string;
  country: string;
  distanceKm: number;
  estimatedMinutes: number;
  difficulty: Difficulty;
  surface: SurfaceType;
  scenery: SceneryType[];
  elevationGainM: number;
  description: string;
  highlights: string[];
  bestTime: string;
  safetyNotes: string[];
  gpxUrl: string;
  rating: number;
}

export interface RouteRecommendation {
  route: RunningRoute;
  matchScore: number;
  reason: string;
}

export function formatDistance(km: number, useMetric: boolean = true): string {
  if (useMetric) return `${km.toFixed(1)} km`;
  return `${(km * 0.621371).toFixed(1)} mi`;
}

export function getDifficultyLabel(d: Difficulty): string {
  const labels: Record<Difficulty, string> = {
    beginner: '🌱 初学者',
    intermediate: '🏃 中级',
    advanced: '🏔️ 高级',
  };
  return labels[d];
}
