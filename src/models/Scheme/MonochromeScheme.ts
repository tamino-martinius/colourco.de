import { Scheme, Mapping } from './Scheme';

export class MonochromeScheme extends Scheme {
  public mappings: Mapping[] = [
    {
      ratio: 1,
      origins: [
        (value, seed) => value,
        (value, seed) => value + seed * 0.1,
        (value, seed) => value + seed,
      ],
    },
  ];
}

export default MonochromeScheme;
