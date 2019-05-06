import { HslColor, RgbColor } from '../Color';

export type OriginFn = (value: number, seed: number) => number;

export interface Mapping {
  ratio: number;
  origins: OriginFn[];
}

export class Scheme {
  public mappings: Mapping[] = [];

  generate(centerHsl: HslColor, count: number) {
    const colors: RgbColor[] = [];
    const counts = this.getCounts(count);
    const hslNorm = centerHsl.norm();
    const range = 0.5;
    const halfRange = range / 2;
    const rangeStep = range / count;
    let seeds = hslNorm.map((num) => Math.max(0, Math.min(1, num + halfRange) - range) - num);

    this.mappings.forEach((mapping, mappingIndex) => {
      for (let colorIndex = 0; colorIndex < counts[mappingIndex]; colorIndex += 1) {
        const [h, s, l] = hslNorm.map((num, index) => mapping.origins[index](num, seeds[index]));
        const hsl = new HslColor(h * 360, s * 100, l * 100);
        const rgb = hsl.toRgb();

        colors.push(rgb);
        seeds = seeds.map((seed) => (seed += rangeStep));
      }
    });

    return colors;
  }

  private getCounts(count: number): number[] {
    const ratios: number[] = this.mappings.map((mapping) => mapping.ratio);
    const counts: number[] = ratios.map((r) => 0);
    const weight = 1 / count;

    for (let i = 0; i < count; i++) {
      let maxRatio = -1;
      let maxRatioIndex = -1;
      ratios.forEach((ratio, index) => {
        if (ratio > maxRatio) {
          maxRatio = ratio;
          maxRatioIndex = index;
        }
      });
      ratios[maxRatioIndex] -= weight;
      counts[maxRatioIndex] += 1;
    }
    return counts;
  }
}

export default Scheme;
