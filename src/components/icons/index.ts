import { Dict, IconType } from '../../types';

const crossSvg = require('./cross.svg');
const downloadSvg = require('./download.svg');
const facebookSvg = require('./facebook.svg');
const gearSvg = require('./gear.svg');
const helpSvg = require('./help.svg');
const leftSvg = require('./left.svg');
const legalSvg = require('./legal.svg');
const logoSvg = require('./logo.svg');
const minusSvg = require('./minus.svg');
const nextcodeSvg = require('./nextcode.svg');
const plusSvg = require('./plus.svg');
const rightSvg = require('./right.svg');
const schemeSvg = require('./scheme.svg');
const togglesSvg = require('./toggles.svg');
const trashSvg = require('./trash.svg');
const twitterSvg = require('./twitter.svg');
import { VueConstructor } from 'vue';

export default <Dict<VueConstructor>>{
  [IconType.CROSS]: crossSvg,
  [IconType.DOWNLOAD]: downloadSvg,
  [IconType.FACEBOOK]: facebookSvg,
  [IconType.GEAR]: gearSvg,
  [IconType.HELP]: helpSvg,
  [IconType.LEFT]: leftSvg,
  [IconType.LEGAL]: legalSvg,
  [IconType.LOGO]: logoSvg,
  [IconType.MINUS]: minusSvg,
  [IconType.NEXTCODE]: nextcodeSvg,
  [IconType.PLUS]: plusSvg,
  [IconType.RIGHT]: rightSvg,
  [IconType.SCHEME]: schemeSvg,
  [IconType.TOGGLES]: togglesSvg,
  [IconType.TRASH]: trashSvg,
  [IconType.TWITTER]: twitterSvg,
};
