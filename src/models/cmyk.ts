import Color, { ColorDefinition } from './color';
import Rgb from './rgb';

export class Cmy extends Color {
  static get definition(): ColorDefinition {
    return {
      c: { min: 0, max: 1, f: 100, name: 'cyan' },
      m: { min: 0, max: 1, f: 100, name: 'magenta' },
      y: { min: 0, max: 1, f: 100, name: 'yellow' },
    };
  }

  toRgb(): Color {
    return new Rgb([
      1 - (this.values[0] * (1 - this.values[3]) + this.values[3]),
      1 - (this.values[1] * (1 - this.values[3]) + this.values[3]),
      1 - (this.values[2] * (1 - this.values[3]) + this.values[3]),
    ]);
  }
};

export default Cmy;
