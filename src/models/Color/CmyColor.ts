import Color from './Color';
import RgbColor from './RgbColor';

export class CmyColor extends Color {
  public static fromRgb(rgb: RgbColor): CmyColor {
    return new CmyColor(...rgb.map((num) => (1 - num / 255) * 100));
  }

  public bounds = [100, 100, 100];

  public toRgb(): RgbColor {
    return new RgbColor(...this.map((num) => (1 - num / 100) * 255));
  }
}

export default CmyColor;
