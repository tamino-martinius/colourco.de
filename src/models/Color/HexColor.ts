import RgbColor from './RgbColor';

export class HexColor extends RgbColor {
  // Workaround is needed because color extends Array
  // see: https://github.com/Microsoft/TypeScript/wiki/FAQ#why-doesnt-extending-built-ins-like-error-array-and-map-work
  constructor(...items: number[]) {
    super(...items);
    Object.setPrototypeOf(this, HexColor.prototype);
  }

  public toString() {
    const values = this.map((num) => `${num.toString(16).padStart(2, '0')}`);
    return `#${values.join('')}`;
  }
}

export default HexColor;
