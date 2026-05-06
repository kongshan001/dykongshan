export interface EmergencyCard {
  country: string;
  police: string;
  fire: string;
  ambulance: string;
  embassyCN: { name: string; address: string; phone: string };
  phrases: { english: string; local: string; pronunciation: string }[];
}
