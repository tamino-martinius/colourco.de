<template>
  <div :class="$style.root">
    <ul>
      <li
        @click="handleSchemeClick('free')"
      >
        free
      </li>
      <li
        :key="scheme"
        v-for="scheme in schemes"
        @click="handleSchemeClick(scheme)"
      >
        {{scheme}}
      </li>
    </ul>

  </div>
</template>

<script lang="ts">
  import { SchemeName } from '../models/scheme';

console.log(
    require('svg-loader!../icons/logo.html'),
  );

  export default {
    data: () => ({
      schemes: <SchemeName[]>[
        'monochrome',
        'monochromeDark',
        'monochromeLight',
        'analogic',
        'complement',
        'analogicComplement',
        'triad',
        'quad',
      ],
      icons: {
        // logo,
      },
    }),
    methods: {
      handleSchemeClick(name: string) {
        this.$emit('changeScheme', name);
      }
    },
  };
</script>

<style lang="stylus" module>
  .root {
    grid-area: nav;
  }
</style>
