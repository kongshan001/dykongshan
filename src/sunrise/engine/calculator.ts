/**
 * 简化版日出日落计算（基于经纬度和日期）
 * 使用 NOAA 太阳计算器算法的简化版本
 */

const DEG = Math.PI / 180;
const RAD = 180 / Math.PI;

function toJulianDate(date: Date): number {
  return date.getTime() / 86400000 + 2440587.5;
}

function solarDeclination(jd: number): number {
  const n = jd - 2451545.0;
  const L = (280.460 + 0.9856474 * n) % 360;
  const g = ((357.528 + 0.9856003 * n) % 360) * DEG;
  const lambda = (L + 1.915 * Math.sin(g) + 0.020 * Math.sin(2 * g)) * DEG;
  return Math.asin(Math.sin(lambda) * Math.sin(23.439 * DEG));
}

export interface SunTimes {
  sunrise: Date;
  sunset: Date;
  goldenHourMorning: Date;
  goldenHourEvening: Date;
}

export function calculateSunTimes(lat: number, lng: number, date: Date): SunTimes {
  const jd = toJulianDate(date);
  const dec = solarDeclination(jd);
  const latRad = lat * DEG;
  
  // 日出日落时角
  const cosH = (Math.sin(-0.833 * DEG) - Math.sin(latRad) * Math.sin(dec)) / (Math.cos(latRad) * Math.cos(dec));
  
  if (cosH > 1) return { sunrise: date, sunset: date, goldenHourMorning: date, goldenHourEvening: date }; // 极夜
  if (cosH < -1) return { sunrise: date, sunset: date, goldenHourMorning: date, goldenHourEvening: date }; // 极昼
  
  const H = Math.acos(cosH) * RAD;
  
  // 太阳正午时间（简化）
  const noon = 12 - lng / 15;
  const sunriseHour = noon - H / 15;
  const sunsetHour = noon + H / 15;
  
  const baseDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  
  const sunrise = new Date(baseDate.getTime() + sunriseHour * 3600000);
  const sunset = new Date(baseDate.getTime() + sunsetHour * 3600000);
  const goldenHourMorning = new Date(sunrise.getTime() + 3600000); // 日出后1小时
  const goldenHourEvening = new Date(sunset.getTime() - 3600000); // 日落前1小时
  
  return { sunrise, sunset, goldenHourMorning, goldenHourEvening };
}
