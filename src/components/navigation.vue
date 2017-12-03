<template>
  <div :class="$style.root" :style="{
    ['--test']: 'fuchsia',
  }">
    <ul>
      <li @click="handleSchemeClick('free')">
        <Icon
          :class="$style.free"
          name="scheme"
        />
      </li>
      <li
        :key="scheme"
        v-for="scheme in schemes"
        @click="handleSchemeClick(scheme)"
      >
        <Icon
          :class="$style[key]"
          name="scheme"
        />
      </li>
      <li @click="handlePageChange('download')">
        <Icon
          :class="$style.download"
          name="download"
        />
      </li>
      <li @click="handlePageChange('help')">
        <Icon
          :class="$style.help"
          name="help"
        />
      </li>
      <li @click="handlePageChange('legal')">
        <Icon
          :class="$style.legal"
          name="legal"
        />
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
  components: {
    Icon,
  },
};
</script>

<style lang="stylus" module>
  .root {
    grid-area: nav;
    li {
      background: var(--test);
    }
  }
</style>
