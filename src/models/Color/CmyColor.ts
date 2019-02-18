import Color from './Color';
import RgbColor from './RgbColor';

export class CmyColor extends Color {
  public static fromRgb(rgb: RgbColor): CmyColor {
    return new CmyColor(...rgb.map((num) => (1 - num / 255) * 100));
  }

  public bounds = [100, 100, 100];

  // Workaround is needed because color extends Array
  // see: https://github.com/Microsoft/TypeScript/wiki/FAQ#why-doesnt-extending-built-ins-like-error-array-and-map-work
  constructor(...items: number[]) {
    super(...items);
    Object.setPrototypeOf(this, CmyColor.prototype);
    this.clamp();
  }

  public toRgb(): RgbColor {
    return new RgbColor(...this.map((num) => (1 - num / 100) * 255));
  }

  public toString() {
    const values = this.map((num) => `${num.toFixed(0)}%`);
    return `cmy(${values.join(', ')})`;
  }
}

export default CmyColor;
