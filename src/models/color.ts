export interface Definition {
  min: number;
  max: number;
  f: number;
  name: string;
};

export interface ColorDefinition {
  [key: string]: Definition;
};

export interface Params {
  [key: string]: number;
};

export abstract class Color {
  static clamp(value: number, min: number, max: number): number {
    return Math.min(max, Math.max(value, min));
  }

  static get keys(): string[] {
    return Object.keys(this.definition);
  }

  static get definition(): ColorDefinition {
    return {};
  }

  constructor(public values: number[]) {
    this.clamp();
  }

  get min(): number {
    return Math.min(...this.values);
  }

  get max(): number {
    return Math.max(...this.values);
  }

  get delta(): number {
    return this.max - this.min;
  }

  clamp(): void {
    let index: number = 0;
    for (const key of this.model.keys) {
      this.values[index] = this.model.clamp(
        this.values[index],
        this.model.definition[key].min,
        this.model.definition[key].max
      );
    }
  }

  abstract toRgb(): Color;

  toFgc(): Color {
    return this.toRgb().toFgc();
  }

  toHex(): Color {
    return this.toRgb().toHex();
  }

  toHsl(): Color {
    return this.toRgb().toHsl();
  }

  toHsv(): Color {
    return this.toRgb().toHsv();
  }

  toCmy(): Color {
    return this.toRgb().toCmy();
  }

  toCmyk(): Color {
    return this.toRgb().toCmyk();
  }

  get model(): typeof Color {
    return <typeof Color>this.constructor;
  }
};

export default Color;
