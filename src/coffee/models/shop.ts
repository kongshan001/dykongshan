export type CoffeeStyle = 'specialty' | 'traditional' | 'fusion' | 'roaster';

export interface CoffeeShop {
  id: string;
  name: string;
  city: string;
  country: string;
  style: CoffeeStyle;
  description: string;
  recommendedDrink: string;
  priceRange: string;
  rating: number;
  address: string;
}
