import Hsl from './hsl';
import Scheme from './scheme';

export type page = 'scheme' | 'help' | 'legal';

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
};

export default State;
