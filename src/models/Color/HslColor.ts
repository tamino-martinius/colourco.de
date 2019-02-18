import Color from './Color';
import RgbColor from './RgbColor';

export class HslColor extends Color {
  public static fromRgb(rgb: RgbColor): HslColor {
    const rgbNorm = rgb.norm();
    const min = Math.min(...rgbNorm);
    const max = Math.max(...rgbNorm);
    const diff = max - min;
    let h = 0;
    let s = 0;
    const l = ((max + min) / 2) * 100;
    if (diff > Color.EPSILON) {
      if (max === rgbNorm[0]) {
        h = 0 + (120 * (rgbNorm[1] - rgbNorm[2])) / diff;
      }
      if (max === rgbNorm[1]) {
        h = 120 + (120 * (rgbNorm[2] - rgbNorm[0])) / diff;
      }
      if (max === rgbNorm[2]) {
        h = 240 + (120 * (rgbNorm[0] - rgbNorm[1])) / diff;
      }
      if (1 - min > Color.EPSILON) {
        s = (diff / (1 - Math.abs(max + min - 1))) * 100;
      }
    }
    return new HslColor(h, s, l);
  }

  public bounds = [360, 100, 100];

  // Workaround is needed because color extends Array
  // see: https://github.com/Microsoft/TypeScript/wiki/FAQ#why-doesnt-extending-built-ins-like-error-array-and-map-work
  constructor(h: number, ...sl: number[]) {
    super(((h % 360) + 360) % 360, ...sl);
    Object.setPrototypeOf(this, HslColor.prototype);
    this.clamp();
  }

  public toRgb(): RgbColor {
    const [h, s, l] = this.norm();
    const H = h * 6;
    const C = (1 - Math.abs(2 * l - 1)) * s;
    const X = C * (1 - Math.abs((H % 2) - 1));
    const m = l - 0.5 * C;
    let r = 0;
    let g = 0;
    let b = 0;
    if ((0 <= H && H < 1) || (5 <= H && H < 6)) {
      r = C;
    }
    if ((1 <= H && H < 2) || (4 <= H && H < 5)) {
      r = X;
    }
    if (1 <= H && H < 3) {
      g = C;
    }
    if ((0 <= H && H < 1) || (3 <= H && H < 4)) {
      g = X;
    }
    if (3 <= H && H < 5) {
      b = C;
    }
    if ((2 <= H && H < 3) || (5 <= H && H < 6)) {
      b = X;
    }
    return new RgbColor((r + m) * 255, (g + m) * 255, (b + m) * 255);
  }

  public toString() {
    const values = this.map((num, index) => `${num.toFixed(0)}${index > 0 ? '%' : ''}`);
    return `hsl(${values.join(', ')})`;
  }
}

export default HslColor;
