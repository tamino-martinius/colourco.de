import RgbColor from './RgbColor';
import HexColor from './HexColor';

export class FgcColor extends HexColor {
  public static fromRgb(rgb: RgbColor): FgcColor {
    const diff = rgb.max() > 255 - FgcColor.offset ? -FgcColor.offset : FgcColor.offset;
    return new FgcColor(...rgb.map((num) => num + diff));
  }

  private static offset = 96;
}

export default HexColor;
