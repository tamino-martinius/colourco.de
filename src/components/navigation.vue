<template>
  <div :class="$style.root">
    <ul>
      <li
        @click="handleSchemeClick('free')"
      >
        <Icon key="scheme"></Icon>
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
import Icon from './icon.vue';


console.log(
  Icon,
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
  complements: {
    Icon,
  },
};
</script>

<style lang="stylus" module>
  .root {
    grid-area: nav;
  }
</style>
