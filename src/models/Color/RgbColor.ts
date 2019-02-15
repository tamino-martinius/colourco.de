import Color from './Color';

export class RgbColor extends Color {
  public static fromRgb(rgb: RgbColor): RgbColor {
    return new RgbColor(...rgb);
  }

  public bounds = [255, 255, 255];

  public toRgb(): RgbColor {
    return new RgbColor(...this);
  }
}

export default RgbColor;
