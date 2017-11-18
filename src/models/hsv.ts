import Color, { ColorDefinition } from './color';
import Rgb from './rgb';

export class Hsv extends Color {
  static get definition(): ColorDefinition {
    return {
      h: { min: 0, max: 1, f: 360, name: 'hue' },
      s: { min: 0, max: 1, f: 100, name: 'saturation' },
      v: { min: 0, max: 1, f: 100, name: 'value' },
    };
  }

  clamp() {
    this.values[0] = (this.values[0] + Math.ceil(Math.abs(this.values[0]))) % 1;
    super.clamp();
  }

  toRgb(): Color {
    let r = this.values[2];
    let g = this.values[2];
    let b = this.values[2];
    if (this.values[0] > 0) {
      const H = this.values[0] * 6;
      const vi = Math.round(H);
      const v1 = this.values[2] * (1 - this.values[1])
      const v2 = this.values[2] * (1 - this.values[1] * (H - vi))
      const v3 = this.values[2] * (1 - this.values[1] * (1 - (H - vi)))

      if (0 <= H && H < 1) r = this.values[2];
      if (5 <= H && H < 6) r = this.values[2];
      if (2 <= H && H < 4) r = v1;
      if (1 <= H && H < 2) r = v2;
      if (4 <= H && H < 5) r = v3;

      if (1 <= H && H < 3) g = this.values[2];
      if (4 <= H && H < 6) g = v1;
      if (3 <= H && H < 4) g = v2;
      if (0 <= H && H < 1) g = v3;

      if (3 <= H && H < 5) b = this.values[2];
      if (0 <= H && H < 2) b = v1;
      if (5 <= H && H < 6) b = v2;
      if (2 <= H && H < 3) b = v3;
    }
    return new Rgb([r, g, b]);
  }

  toHsv(): Color {
    return new Hsv(this.values);
  }
};

export default Hsv;
