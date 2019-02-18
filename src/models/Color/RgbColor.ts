import Color from './Color';

export class RgbColor extends Color {
  public static bounds = [255, 255, 255];

  public static fromRgb(rgb: RgbColor): RgbColor {
    return new RgbColor(...rgb.values);
  }

  public toRgb(): RgbColor {
    return new RgbColor(...this.values);
  }

  public toString() {
    const values = this.map((num) => num.toFixed(0));
    return `rgb(${values.join(', ')})`;
  }
}

export default RgbColor;
