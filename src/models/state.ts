import Hsl from './hsl';
import Scheme from './scheme';

export type page = 'scheme' | 'help' | 'legal';
export interface Position {
  x: number;
  y: number;
  isActive: boolean;
};

export class State {
  public editIndex?: number = 0;
  public currentPage: page = 'scheme';
  public swatches: Hsl[] = [Scheme.randomPastelColor];
  public maxSwatches: number = 10;

  get canAdd(): boolean {
    return this.swatches.length < this.maxSwatches && !this.isEditing;
  }

  get canRemove(): boolean {
    return this.swatches.length > 0 && !this.isEditing;
  }

  get showScheme(): boolean {
    return this.currentPage === 'scheme';
  }

  get showHelp(): boolean {
    return this.currentPage === 'help';
  }

  get showLegal(): boolean {
    return this.currentPage === 'legal';
  }

  get isEditing(): boolean {
    return this.editIndex !== undefined;
  }

  get positions(): Position[] {
    return this.swatches.map((hsl, index) =>
      ({
        x: hsl.values[0],
        y: hsl.values[2],
        color: hsl.toString(),
        isActive: index === this.editIndex,
      })
    )
  }
};

export default State;
