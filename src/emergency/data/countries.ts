import { EmergencyCard } from '../models/card';

export const EMERGENCY_DATA: EmergencyCard[] = [
  { country: '日本', police: '110', fire: '119', ambulance: '119', embassyCN: { name: '中国驻日本大使馆', address: '东京都港区元麻布3-4-33', phone: '+81-3-3479-6380' }, phrases: [{ english: 'Help!', local: '助けて！', pronunciation: 'Tasukete!' }, { english: 'I need a doctor', local: '医者が必要です', pronunciation: 'Isha ga hitsuyō desu' }] },
  { country: '泰国', police: '191', fire: '199', ambulance: '1669', embassyCN: { name: '中国驻泰国大使馆', address: '57 Ratchadaphisek Rd, Bangkok', phone: '+66-2-245-7044' }, phrases: [{ english: 'Help!', local: 'ช่วยด้วย!', pronunciation: 'Chuay duay!' }] },
  { country: '法国', police: '17', fire: '18', ambulance: '15', embassyCN: { name: '中国驻法国大使馆', address: '11 Ave George V, Paris', phone: '+33-1-4952-1950' }, phrases: [{ english: 'Help!', local: 'Au secours!', pronunciation: 'Oh se-coor!' }] },
  { country: '美国', police: '911', fire: '911', ambulance: '911', embassyCN: { name: '中国驻美大使馆', address: '3505 International Ct NW, Washington DC', phone: '+1-202-495-2200' }, phrases: [{ english: 'Help!', local: 'Help!', pronunciation: 'Help!' }] },
  { country: '澳大利亚', police: '000', fire: '000', ambulance: '000', embassyCN: { name: '中国驻澳大使馆', address: '15 Coronation Dr, Yarralumla ACT', phone: '+61-2-6228-3948' }, phrases: [{ english: 'Help!', local: 'Help!', pronunciation: 'Help!' }] },
];
