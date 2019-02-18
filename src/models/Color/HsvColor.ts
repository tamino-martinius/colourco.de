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
        h = 0 + (120 * (rgbNorm[1] - rgbNorm[2])) / diff;
      }
      if (max === rgbNorm[1]) {
        h = 120 + (120 * (rgbNorm[2] - rgbNorm[0])) / diff;
      }
      if (max === rgbNorm[2]) {
        h = 240 + (120 * (rgbNorm[0] - rgbNorm[1])) / diff;
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
    let r = v;
    let g = v;
    let b = v;
    const H = h * 6;
    const hDiff = H - Math.round(H);
    const v1 = v * (1 - s);
    const v2 = v * (1 - s * hDiff);
    const v3 = v * (1 - s * (1 - hDiff));
    if (s > Color.EPSILON) {
      if ((0 <= H && H < 1) || (5 <= H && H < 6)) {
        r = v;
      }
      if (2 <= H && H < 4) {
        r = v1;
      }
      if (1 <= H && H < 2) {
        r = v2;
      }
      if (4 <= H && H < 5) {
        r = v3;
      }
      if (1 <= H && H < 3) {
        g = v;
      }
      if (4 <= H && H < 6) {
        g = v1;
      }
      if (3 <= H && H < 4) {
        g = v2;
      }
      if (0 <= H && H < 1) {
        g = v3;
      }
      if (3 <= H && H < 5) {
        b = v;
      }
      if (0 <= H && H < 2) {
        b = v1;
      }
      if (5 <= H && H < 6) {
        b = v2;
      }
      if (2 <= H && H < 3) {
        b = v3;
      }
    }
    return new RgbColor(r * 255, g * 255, b * 255);
  }

  public toString() {
    const values = this.map((num, index) => `${num.toFixed(0)}${index > 0 ? '%' : ''}`);
    return `hsv(${values.join(', ')})`;
  }
}

export default HsvColor;
