import Color from './Color';
import RgbColor from './RgbColor';

export class HsvColor extends Color {
  public static bounds = [360, 100, 100];

  public static fromRgb(rgb: RgbColor): HsvColor {
    const rgbNorm = rgb.norm();
    const min = Math.min(...rgbNorm);
    const max = Math.max(...rgbNorm);
    const diff = max - min;
    let h = 0;
    let s = 0;
    const v = max * 100;
    if (diff > Color.EPSILON) {
      if (max === rgbNorm[0]) {
        h = 60 * (0 + (rgbNorm[1] - rgbNorm[2]) / diff);
      }
      if (max === rgbNorm[1]) {
        h = 60 * (2 + (rgbNorm[2] - rgbNorm[0]) / diff);
      }
      if (max === rgbNorm[2]) {
        h = 60 * (4 + (rgbNorm[0] - rgbNorm[1]) / diff);
      }
      s = (diff / max) * 100;
    }
    return new HsvColor(h, s, v);
  }

  constructor(h: number, ...sv: number[]) {
    super(((h % 360) + 360) % 360, ...sv);
  }

  public toRgb(): RgbColor {
    const [h, s, v] = this.norm();
    let r = 0;
    let g = 0;
    let b = 0;
    const C = v * s;
    const H = h * 6;
    const X = C * (1 - Math.abs((H % 2) - 1));
    const m = v - C;
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
    return `hsv(${values.join(', ')})`;
  }
}

export default HsvColor;
