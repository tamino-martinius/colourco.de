import Color from './color';
import Hsl from './hsl';

export type ColorMode =
  'single' |
  'fixed' |
  'global' |
  'uniform'
;
export type SchemeName =
  'monochrome' |
  'monochromeDark' |
  'monochromeLight' |
  'analogic' |
  'complement' |
  'analogicComplement' |
  'triad' |
  'quad'
;
export interface Mapping {
  mode: ColorMode;
  origin: (value: number, seed: number) => number;
};
export interface ColorMapping {
  ratio: number;
  mappings: Mapping[];
};
export type ColorScheme = ColorMapping[];
export interface ColorSchemes {
  [key: string]: ColorScheme;
}

export class Scheme {
  colors: Color[];

  static get schemes(): ColorSchemes {
    return {
      monochrome: [
        {
          ratio: 1,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value },
            { mode: 'single', origin: (value, seed) => value + seed * 0.1 },
            { mode: 'uniform', origin: (value, seed) => value + seed },
          ],
        },
      ],
      monochromeDark: [
        {
          ratio: 0.4,
          mappings: [
            { mode: 'fixed', origin: (_value, _seed) => 0 },
            { mode: 'fixed', origin: (_value, _seed) => 0 },
            { mode: 'uniform', origin: ( value, seed) => value + seed },
          ],
        },
        {
          ratio: 0.6,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value },
            { mode: 'single', origin: (value, seed) => value + seed * 0.1 },
            { mode: 'uniform', origin: (value, seed) => value + seed },
          ],
        },
      ],
      monochromeLight: [
        {
          ratio: 0.6,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value },
            { mode: 'single', origin: (value, seed) => value + seed * 0.1 },
            { mode: 'uniform', origin: (value, seed) => value + seed },
          ],
        },
        {
          ratio: 0.4,
          mappings: [
            { mode: 'fixed', origin: (_value, _seed) => 0 },
            { mode: 'fixed', origin: (_value, _seed) => 0 },
            { mode: 'uniform', origin: (value, seed) => value + seed },
          ],
        },
      ],
      analogic: [
        {
          ratio: 1,
          mappings: [
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.5 },
            { mode: 'global', origin: (value, seed) => value + seed * 0.1 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.1 },
          ],
        },
      ],
      complement: [
        {
          ratio: 0.4,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value + 0.5 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
        {
          ratio: 0.6,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
      ],
      analogicComplement: [
        {
          ratio: 0.4,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value + 0.5 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.5 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.5 },
          ],
        },
        {
          ratio: 0.6,
          mappings: [
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.75 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.1 },
            { mode: 'global', origin: (value, seed) => value + seed * 0.1 },
          ],
        },
      ],
      triad: [
        {
          ratio: 0.25,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value + 0.33 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
        {
          ratio: 0.25,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value - 0.33 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
        {
          ratio: 0.5,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
      ],
      quad: [
        {
          ratio: 0.20,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value + 0.25 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
        {
          ratio: 0.20,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value + 0.5 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
        {
          ratio: 0.20,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value - 0.25 },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
        {
          ratio: 0.40,
          mappings: [
            { mode: 'global', origin: (value, _seed) => value },
            { mode: 'single', origin: (value, seed) => value + seed * 0.25 },
            { mode: 'uniform', origin: (value, seed) => value + seed * 0.25 },
          ],
        },
      ],
    };
  }

  static generate(name: SchemeName, color: Hsl, count: number): Hsl[] {
    const ratios: number[] = []
    const counts: number[] = []
    const colorScheme: ColorScheme = this.schemes[name];
    const colors: Hsl[] = []
    for (const colorMapping of colorScheme) {
      ratios.push(colorMapping.ratio);
      counts.push(0);
    }
    const colorWeight = 1 / count;
    for (let colorIndex = 0; colorIndex < count; colorIndex++) {
      let maxRatio = -1
      let maxRatioIndex = -1
      for (let ratioIndex = 0; ratioIndex < ratios.length; ratioIndex++) {
        const ratio = ratios[ratioIndex];
        if (ratio > maxRatio) {
          maxRatio = ratio;
          maxRatioIndex = ratioIndex;
        }
      }
      ratios[maxRatioIndex] -= colorWeight;
      counts[maxRatioIndex] += 1;
    }
    const seed = 0.5
    const seedStep = seed / count;
    let hSeed = 0;
    const sMaxSeed = Math.min(1, color.values[1] + seed / 2);
    const sMinSeed = Math.max(0, sMaxSeed - seed);
    let sSeed = sMinSeed - color.values[1];
    const lMaxSeed = Math.min(1, color.values[2] + seed / 2);
    const lMinSeed = Math.max(0, lMaxSeed - seed);
    let lSeed = lMinSeed - color.values[2];
    for (let colorMappingIndex = 0; colorMappingIndex < colorScheme.length; colorMappingIndex++) {
      const colorMapping = colorScheme[colorMappingIndex];
      for (let index = 0; index < counts[colorMappingIndex]; index++) {
        let h = colorMapping.mappings[0].origin(color.values[0], hSeed);
        if (h < 0) h += 1;
        if (h > 1) h -= 1;
        hSeed += seedStep;
        const s = colorMapping.mappings[1].origin(color.values[1], sSeed);
        sSeed += seedStep;
        const l = colorMapping.mappings[2].origin(color.values[2], lSeed);
        lSeed += seedStep;
        colors.push(new Hsl(h, s, l));
      }
    }
    return colors;
  }
};

export default Scheme;
