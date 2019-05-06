<template>
  <section ref="main" @mousemove="updateColorPosition" @scroll="updateColorSaturtion">
    <Swatch v-for="(color, index) in colors" :key="index" :color="color" class="swatch"/>
  </section>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import Swatch from '@/components/Swatch.vue';
import { CmyColor, CmykColor, RgbColor, HslColor, HsvColor } from '@/models/Color';
import { MonochromeScheme } from '@/models/Scheme';

@Component({
  components: {
    Swatch,
  },
})
export default class Monochrome extends Vue {
  private locked = false;
  private baseColor = new HslColor(Math.random() * 360, 50, 50);
  private count = 5;
  private scheme = new MonochromeScheme();
  private colors = this.generateColors(this.scheme, this.baseColor, this.count);

  private generateColors(scheme = this.scheme, baseColor = this.baseColor, count = this.count) {
    const colors = scheme.generate(baseColor, count);
    // tslint:disable-next-line:no-console
    // console.log({ baseColor, count, scheme, colors });
    return colors;
  }

  private updateColorPosition(e: MouseEvent) {
    const bounds = (this.$refs.main as HTMLElement).getBoundingClientRect();
    const x = Math.max(0, Math.min(1, (e.clientX - bounds.left) / bounds.width));
    const y = 1 - Math.max(0, Math.min(1, (e.clientY - bounds.top) / bounds.height));

    this.baseColor = new HslColor(x * 360, 50, y * 100);
    this.colors = this.generateColors();
  }

  private updateColorSaturtion(e: MouseEvent) {
    // console.debug(e);
  }
}
</script>

<style scoped>
section {
  display: flex;
  flex: 1;
}

.swatch {
  flex: 1;
}
</style>
