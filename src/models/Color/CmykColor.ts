import CmyColor from './CmyColor';
import RgbColor from './RgbColor';
import Color from './Color';

export class CmykColor extends CmyColor {
  public static fromRgb(rgb: RgbColor): CmykColor {
    const cmy = super.fromRgb(rgb);
    const k = cmy.min();
    const inv = 100 - k;
    if (inv < Color.EPSILON) {
      return new CmykColor(0, 0, 0, 100);
    }
    return new CmykColor(...cmy.map((num) => (num - k) / inv), k);
  }

  public bounds = [100, 100, 100, 100];

  public toRgb(): RgbColor {
    const cmy = this.slice(0, 3);
    const k = this[3];
    const inv = 100 - k;
    return new CmyColor(...cmy.map((num) => num * inv + k)).toRgb();
  }
}

export default CmykColor;
