import Swatch from './swatch';

export type page = 'scheme' | 'help' | 'legal';

export class State {
  public isEditing: boolean = true;
  public currentPage: page = 'scheme';
  public swatches: Swatch[] = [];
  public maxSwatches: number = 10;

  getCanAdd(): boolean {
    return this.swatches.length < this.maxSwatches && !this.isEditing;
  }

  getCanRemove(): boolean {
    return this.swatches.length > 0 && !this.isEditing;
  }
};

export default State;
