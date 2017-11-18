import Color, { ColorDefinition } from './color';
import Rgb from './rgb';

export class Hsl extends Color {
  static get definition(): ColorDefinition {
    return {
      h: { min: 0, max: 1, f: 360, name: 'hue' },
      s: { min: 0, max: 1, f: 100, name: 'saturation' },
      l: { min: 0, max: 1, f: 100, name: 'lightness' },
    };
  }

  clamp() {
    this.values[0] = (this.values[0] + Math.ceil(Math.abs(this.values[0]))) % 1;
    super.clamp();
  }

  toRgb(): Color {
    // H ∊[0, 6[  hue * 6
    const H = this.values[0] * 6.0;
    // C ∊[0, 1]  chroma
    const C = (1 - Math.abs(2 * this.values[2] - 1)) * this.values[1];
    // X ∊[0, 1]  intermediate
    const X = C * (1 - Math.abs(H % 2 - 1));

    let r = 0;
    let g = 0;
    let b = 0;
    if ((0 <= H && H < 1) || (5 <= H && H < 6)) r = C;
    if ((1 <= H && H < 2) || (4 <= H && H < 5)) r = X;
    if ( 1 <= H && H < 3)                       g = C;
    if ((0 <= H && H < 1) || (3 <= H && H < 4)) g = X;
    if ( 3 <= H && H < 5)                       b = C;
    if ((2 <= H && H < 3) || (5 <= H && H < 6)) b = X;

    // match lightness
    const m = this.values[2] - 0.5 * C;

    return new Rgb([
      r + m,
      g + m,
      b + m,
    ]);
  }
};

export default Hsl;
