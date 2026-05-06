/**
 * 音频资源管理器 - 下载、缓存、离线支持
 */

export interface CacheEntry {
  url: string;
  blob: Blob;
  timestamp: number;
  size: number;
}

const CACHE_PREFIX = 'meditation_audio_';
const CACHE_EXPIRY_MS = 7 * 24 * 60 * 60 * 1000; // 7 天

class AudioResourceManager {
  private cache = new Map<string, CacheEntry>();
  private db: IDBDatabase | null = null;
  private dbReady: Promise<void>;

  constructor() {
    this.dbReady = this.initDB();
  }

  private async initDB(): Promise<void> {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open('MeditationAudioCache', 1);
      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.db = request.result;
        resolve();
      };
      request.onupgradeneeded = (event) => {
        const db = (event.target as IDBOpenDBRequest).result;
        if (!db.objectStoreNames.contains('audio_cache')) {
          db.createObjectStore('audio_cache', { keyPath: 'url' });
        }
      };
    });
  }

  async getAudio(url: string): Promise<Blob | null> {
    // 内存缓存
    const memEntry = this.cache.get(url);
    if (memEntry && Date.now() - memEntry.timestamp < CACHE_EXPIRY_MS) {
      return memEntry.blob;
    }

    await this.dbReady;
    if (!this.db) return null;

    // IndexedDB 缓存
    return new Promise((resolve) => {
      const tx = this.db!.transaction('audio_cache', 'readonly');
      const store = tx.objectStore('audio_cache');
      const req = store.get(url);
      req.onsuccess = () => {
        const entry = req.result;
        if (entry && Date.now() - entry.timestamp < CACHE_EXPIRY_MS) {
          this.cache.set(url, entry);
          resolve(entry.blob);
        } else {
          resolve(null);
        }
      };
      req.onerror = () => resolve(null);
    });
  }

  async downloadAndCache(url: string): Promise<Blob> {
    // 检查缓存
    const cached = await this.getAudio(url);
    if (cached) return cached;

    // 下载
    const response = await fetch(url);
    if (!response.ok) throw new Error(`Failed to fetch ${url}: ${response.status}`);
    const blob = await response.blob();

    // 写入缓存
    const entry: CacheEntry = { url, blob, timestamp: Date.now(), size: blob.size };
    this.cache.set(url, entry);

    await this.dbReady;
    if (this.db) {
      const tx = this.db.transaction('audio_cache', 'readwrite');
      tx.objectStore('audio_cache').put(entry);
    }

    return blob;
  }

  async preloadAll(urls: string[]): Promise<void> {
    await Promise.all(urls.map((url) => this.downloadAndCache(url).catch(() => {})));
  }

  async getCacheSize(): Promise<number> {
    let total = 0;
    for (const entry of this.cache.values()) {
      total += entry.size;
    }
    return total;
  }

  async clearExpired(): Promise<void> {
    const now = Date.now();
    for (const [url, entry] of this.cache) {
      if (now - entry.timestamp > CACHE_EXPIRY_MS) {
        this.cache.delete(url);
      }
    }
    // 同步清理 IndexedDB
    await this.dbReady;
    if (!this.db) return;
    const tx = this.db.transaction('audio_cache', 'readwrite');
    const store = tx.objectStore('audio_cache');
    const req = store.openCursor();
    req.onsuccess = (event) => {
      const cursor = (event.target as IDBRequest).result;
      if (cursor) {
        if (now - cursor.value.timestamp > CACHE_EXPIRY_MS) {
          cursor.delete();
        }
        cursor.continue();
      }
    };
  }
}

export const audioManager = new AudioResourceManager();
