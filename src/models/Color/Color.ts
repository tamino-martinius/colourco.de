import ColorFormat from './ColorFormat';

export abstract class Color extends Array<number> {
  public static EPSILON = 0.01;
  public abstract bounds: number[];

  public norm(): number[] {
    return this.map((num, index) => num / this.bounds[index]);
  }

  public min(): number {
    return Math.min(...this);
  }

  public max(): number {
    return Math.max(...this);
  }

  protected clamp(): void {
    for (let index = 0; index < this.length; index += 1) {
      this[index] = Math.max(0, Math.min(this.bounds[index]), this[index]);
    }
  }
}

export default Color;
