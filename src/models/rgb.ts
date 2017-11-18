import Color, { ColorDefinition } from './color';
import Hex from './hex';
import Hsl from './hsl';
import Hsv from './hsv';
import Cmy from './cmy';
import Cmyk from './cmyk';

const lightThreshold = 96 / 255;

const Rgb = class Rgb extends Color {
  static get definition(): ColorDefinition {
    return {
      r: { min: 0, max: 1, f: 255, name: 'red' },
      g: { min: 0, max: 1, f: 255, name: 'green' },
      b: { min: 0, max: 1, f: 255, name: 'blue' },
    };
  }

  get isLight(): boolean {
    return this.min > lightThreshold;
  }

  toRgb(): Color {
    return this;
  }

  toFgc(): Color {
    const offset = this.isLight ? -lightThreshold : lightThreshold;

    return new Rgb([
      this.values[0] + offset,
      this.values[1] + offset,
      this.values[2] + offset,
    ]);
  }

  toHex(): Color {
    return new Hex(this.values);
  }

  get hue(): number {
    const d2 = this.delta / 2;
    const dr = (((this.max - this.values[0]) / 6) + d2) / this.delta;
    const dg = (((this.max - this.values[1]) / 6) + d2) / this.delta;
    const db = (((this.max - this.values[2]) / 6) + d2) / this.delta;
    if (this.values[0] === this.max) {
      return (0 / 3) + db - dg;
    } else if (this.values[1] === this.max) {
      return (1 / 3) + dr - db;
    } else {
      return (2 / 3) + dg - dr;
    }
  }

  toHsl() {
    const l = (this.min + this.max) / 2;
    if (this.delta > 0) {
      const s = l < 0.5 ?
        this.delta / (l * 2) :
        this.delta / (2 - this.min - this.max);
      return new Hsl([this.hue, s, l]);
    } else {
      return new Hsl([0, 0, l]);
    }
  }

  toHsv() {
    const v = this.max;
    if (this.delta > 0) {
      return new Hsv([this.hue, this.delta / this.max, v]);
    } else {
      return new Hsv([0, 0, v]);
    }
  }

  toCmy() {
    return new Cmy([
      1 - this.values[0],
      1 - this.values[1],
      1 - this.values[2],
    ]);
  }

  toCmyk() {
    const k = 1 - this.max;
    if (k > 0.997) {
      return new Cmyk([0, 0, 0, 1]);
    } else {
      return new Cmyk([
        (1 - this.values[0] - k) / (1 - k),
        (1 - this.values[1] - k) / (1 - k),
        (1 - this.values[2] - k) / (1 - k),
        k,
      ]);
    }
  }
};

export default Rgb;
