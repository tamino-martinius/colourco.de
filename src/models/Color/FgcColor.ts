import RgbColor from './RgbColor';
import HexColor from './HexColor';

export class FgcColor extends HexColor {
  public static fromRgb(rgb: RgbColor): FgcColor {
    const diff = rgb.max() > 255 - FgcColor.offset ? -FgcColor.offset : FgcColor.offset;
    return new FgcColor(...rgb.map((num) => num + diff));
  }

  private static offset = 96;

  // Workaround is needed because color extends Array
  // see: https://github.com/Microsoft/TypeScript/wiki/FAQ#why-doesnt-extending-built-ins-like-error-array-and-map-work
  constructor(...items: number[]) {
    super(...items);
    Object.setPrototypeOf(this, FgcColor.prototype);
  }
}

export default HexColor;
