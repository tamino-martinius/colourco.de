import ColorFormat from './ColorFormat';

export abstract class Color {
  public static EPSILON = 0.01;
  public static bounds: number[];

  protected values: number[];

  constructor(...values: number[]) {
    this.values = values;
    this.clamp();
  }

  public map<T>(fn: (num: number, index: number) => T): T[] {
    return this.values.map(fn);
  }

  public norm(): number[] {
    const { bounds } = this.constructor as typeof Color;
    return this.map((num, index) => num / bounds[index]);
  }

  public min(): number {
    return Math.min(...this.values);
  }

  public max(): number {
    return Math.max(...this.values);
  }

  protected clamp(): void {
    const { bounds } = this.constructor as typeof Color;
    this.values = this.values.map((num, index) => Math.max(0, Math.min(bounds[index], num)));
  }
}

export default Color;
