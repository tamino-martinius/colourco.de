import Color, { ColorDefinition } from './color';
import Rgb from './rgb';

export class Hex extends Color {
  static get definition(): ColorDefinition {
    return {
      r: { min: 0, max: 1, f: 255, name: 'red' },
      g: { min: 0, max: 1, f: 255, name: 'green' },
      b: { min: 0, max: 1, f: 255, name: 'blue' },
    };
  }

  toRgb(): Color {
    return new Rgb(...this.values);
  }

  toHex(): Color {
    return new Hex(...this.values);
  }
};

export default Hex;
