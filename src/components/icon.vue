<template>
<div>
  test
</div>
  <!-- <svg
    :viewBox="icon.attributes.viewBox"
    v-html="icon.content"
  ></svg> -->
</template>

<script lang="ts">
// export interface SvgAttributes {
//   width: string;
//   height: string;
//   viewBox: string;
//   [key: string]: string;
// };

// export interface Svg {
//   attributes: SvgAttributes;
//   content: string;
// };

// export interface icons {
//   logo: Svg;
//   scheme: Svg;
// };

// export type iconName = 'cross' |  'download' |  'gear' |  'left' |  'logo' |
//   'minus' |  'plus' |  'right' |  'scheme' |  'toggles' |  'trash'
// ;

export default {
  props: [
    'key',
  ],
  computed: {
    icon() {
      return require(`svg-loader!../icons/${this.key}.html`);
    },
  },
};
</script>
