<template>
  <div
    class="swatch"
    :style="{'--background': color, '--content': displayColor, '--color': foreColor}"
  ></div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';
import { FgcColor, HexColor, RgbColor } from '@/models/Color';

@Component
export default class Swatch extends Vue {
  @Prop() private color!: RgbColor;

  private get displayColor() {
    return `"${HexColor.fromRgb(this.color)}"`;
  }

  private get foreColor() {
    return FgcColor.fromRgb(this.color);
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.swatch {
  background-color: var(--background);
  color: var(--color);
}

.swatch::after {
  content: var(--content);
}
</style>
