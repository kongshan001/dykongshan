export type PlanType = 'wifi' | 'sim' | 'esim';

export interface ConnectivityPlan {
  country: string; type: PlanType; provider: string; name: string;
  price: string; dataGB: number; days: number; speed: string; notes: string;
}

export const PLANS: ConnectivityPlan[] = [
  { country: '日本', type: 'esim', provider: 'Airalo', name: 'Ueno 30GB', price: '$27', dataGB: 30, days: 30, speed: '4G/LTE', notes: '覆盖全日本，含冲绳' },
  { country: '日本', type: 'wifi', provider: '环球漫游', name: '日本WiFi蛋', price: '¥25/天', dataGB: 999, days: 1, speed: '4G', notes: '多人共享，机场取还' },
  { country: '泰国', type: 'esim', provider: 'AIS', name: 'Traveller SIM', price: '฿299', dataGB: 8, days: 7, speed: '4G/5G', notes: '含通话，7-11有售' },
  { country: '美国', type: 'esim', provider: 'T-Mobile', name: 'Tourist Plan', price: '$30', dataGB: 10, days: 14, speed: '5G', notes: '机场有售' },
  { country: '欧洲', type: 'esim', provider: 'Orange', name: 'Holiday Europe', price: '€20', dataGB: 10, days: 14, speed: '4G', notes: '覆盖EU 30国' },
];
