import RgbColor from './RgbColor';

export class HexColor extends RgbColor {
  public static fromRgb(rgb: RgbColor): HexColor {
    return new HexColor(...rgb.values);
  }

  public toString() {
    const values = this.map((num) => `${num.toString(16).padStart(2, '0')}`);
    return `#${values.join('')}`;
  }
}

export default HexColor;
