/**
 * 冥想播放器 - 支持引导语音 + 背景音混合播放
 */

import { MeditationScene, DURATION_OPTIONS } from '../models/scene-config';

export type PlayerState = 'idle' | 'loading' | 'playing' | 'paused' | 'completed';

export interface PlaybackProgress {
  elapsed: number;       // 已播放秒数
  remaining: number;     // 剩余秒数
  percentage: number;    // 0-100
}

export class MeditationPlayer {
  private state: PlayerState = 'idle';
  private scene: MeditationScene | null = null;
  private duration: number = 0;
  private elapsed: number = 0;
  private startTime: number = 0;
  private pausedElapsed: number = 0;

  private voiceAudio: HTMLAudioElement | null = null;
  private bgAudio: HTMLAudioElement | null = null;

  private timer: ReturnType<typeof setInterval> | null = null;
  private onStateChange?: (state: PlayerState) => void;
  private onProgress?: (progress: PlaybackProgress) => void;
  private onComplete?: () => void;

  constructor(callbacks?: {
    onStateChange?: (state: PlayerState) => void;
    onProgress?: (progress: PlaybackProgress) => void;
    onComplete?: () => void;
  }) {
    if (callbacks) {
      this.onStateChange = callbacks.onStateChange;
      this.onProgress = callbacks.onProgress;
      this.onComplete = callbacks.onComplete;
    }
  }

  async start(scene: MeditationScene, durationOptionIndex: number = 0): Promise<void> {
    this.scene = scene;
    this.duration = DURATION_OPTIONS[durationOptionIndex]?.seconds ?? scene.defaultDuration;
    this.elapsed = 0;
    this.pausedElapsed = 0;

    this.setState('loading');

    try {
      // 创建音频元素
      this.voiceAudio = new Audio(scene.guidedVoice);
      this.bgAudio = new Audio(scene.backgroundSound);
      this.bgAudio.loop = true;
      this.bgAudio.volume = 0.3;
      this.voiceAudio.volume = 0.8;

      await Promise.all([
        this.voiceAudio.play().catch(() => {}),
        this.bgAudio.play().catch(() => {}),
      ]);

      this.startTime = Date.now();
      this.startTimer();
      this.setState('playing');
    } catch (error) {
      this.setState('idle');
      throw error;
    }
  }

  pause(): void {
    if (this.state !== 'playing') return;
    this.pausedElapsed = this.elapsed;
    this.voiceAudio?.pause();
    this.bgAudio?.pause();
    this.stopTimer();
    this.setState('paused');
  }

  resume(): void {
    if (this.state !== 'paused') return;
    this.voiceAudio?.play().catch(() => {});
    this.bgAudio?.play().catch(() => {});
    this.startTime = Date.now() - this.pausedElapsed * 1000;
    this.startTimer();
    this.setState('playing');
  }

  stop(): void {
    this.voiceAudio?.pause();
    this.bgAudio?.pause();
    this.voiceAudio = null;
    this.bgAudio = null;
    this.stopTimer();
    this.setState('idle');
  }

  getState(): PlayerState {
    return this.state;
  }

  getProgress(): PlaybackProgress {
    const elapsed = this.elapsed;
    const remaining = Math.max(0, this.duration - elapsed);
    return {
      elapsed,
      remaining,
      percentage: Math.min(100, (elapsed / this.duration) * 100),
    };
  }

  private startTimer(): void {
    this.timer = setInterval(() => {
      this.elapsed = (Date.now() - this.startTime) / 1000;
      this.onProgress?.(this.getProgress());

      if (this.elapsed >= this.duration) {
        this.complete();
      }
    }, 500);
  }

  private stopTimer(): void {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  private complete(): void {
    this.stopTimer();
    this.voiceAudio?.pause();
    this.bgAudio?.pause();
    this.setState('completed');
    this.onComplete?.();
  }

  private setState(state: PlayerState): void {
    this.state = state;
    this.onStateChange?.(state);
  }
}
