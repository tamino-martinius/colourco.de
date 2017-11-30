export interface SvgAttributes {
  width: string;
  height: string;
  viewBox: string;
  [key: string]: string;
};

export interface Svg {
  attributes: SvgAttributes;
  content: string;
};

export interface icons {
  logo: Svg;
  scheme: Svg;
};

export type iconName = 'cross' |  'download' |  'gear' |  'left' |  'logo' |
  'minus' |  'plus' |  'right' |  'scheme' |  'toggles' |  'trash'
;

export type Icons = {
  readonly [P in  iconName]: Svg;
};

export const cross: Svg = <Svg>require('svg-loader!../icons/cross.html');
export const download: Svg = <Svg>require('svg-loader!../icons/download.html');
export const gear: Svg = <Svg>require('svg-loader!../icons/gear.html');
export const left: Svg = <Svg>require('svg-loader!../icons/left.html');
export const logo: Svg = <Svg>require('svg-loader!../icons/logo.html');
export const minus: Svg = <Svg>require('svg-loader!../icons/minus.html');
export const plus: Svg = <Svg>require('svg-loader!../icons/plus.html');
export const right: Svg = <Svg>require('svg-loader!../icons/right.html');
export const scheme: Svg = <Svg>require('svg-loader!../icons/scheme.html');
export const toggles: Svg = <Svg>require('svg-loader!../icons/toggles.html');
export const trash: Svg = <Svg>require('svg-loader!../icons/trash.html');

export const icons: Icons = {
  cross,
  download,
  gear,
  left,
  logo,
  minus,
  plus,
  right,
  scheme,
  toggles,
  trash,
};

export const getIcon = (name: iconName, width?: string, height?: string): string => {
  const icon: Svg = icons[name];
  const attributes: SvgAttributes = icon.attributes;
  return `
    <svg
      viewBox="${attributes.viewBox}"
      width="${width || attributes.width}"
      height="${height || attributes.height}"
    >
      ${icon.content}
    </svg>
  `;
};
