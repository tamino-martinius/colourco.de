export * from './CmyColor';
export * from './CmykColor';
export * from './FgcColor';
export * from './HexColor';
export * from './HslColor';
export * from './HsvColor';
export * from './RgbColor';

import CmyColor from './CmyColor';
import CmykColor from './CmykColor';
import HexColor from './HexColor';
import HslColor from './HslColor';
import HsvColor from './HsvColor';
import RgbColor from './RgbColor';

export type AnyColor = CmyColor | CmykColor | HexColor | HslColor | HsvColor | RgbColor;
