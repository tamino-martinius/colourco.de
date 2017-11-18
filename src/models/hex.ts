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

  toHex(): Color {
    return this;
  }

  toRgb(): Color {
    return new Rgb(this.values);
  }
};

export default Hex;
