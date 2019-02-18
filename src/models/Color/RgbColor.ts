import Color from './Color';

export class RgbColor extends Color {
  public static fromRgb(rgb: RgbColor): RgbColor {
    return new RgbColor(...rgb);
  }

  public bounds = [255, 255, 255];

  // Workaround is needed because color extends Array
  // see: https://github.com/Microsoft/TypeScript/wiki/FAQ#why-doesnt-extending-built-ins-like-error-array-and-map-work
  constructor(...items: number[]) {
    super(...items);
    Object.setPrototypeOf(this, RgbColor.prototype);
    console.log(this.toString());

    this.clamp();
  }

  public toRgb(): RgbColor {
    return new RgbColor(...this);
  }

  public toStyle() {
    return 'x';
    // const values = this.map((num) => num.toFixed(0));
    // return `rgb(${values.join(', ')})`;
  }
}

export default RgbColor;
