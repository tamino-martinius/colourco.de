import Swatch from './swatch';

export type page = 'scheme' | 'help' | 'legal';

export class State {
  public isEditing: boolean = true;
  public currentPage: page = 'scheme';
  public swatches: Swatch[] = [];
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
};

export default State;
