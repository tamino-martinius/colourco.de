<template>
  <section ref="main" @mousemove="updateColor">
    <Swatch v-for="(color, index) in colors" :key="index" :color="color" class="swatch"/>
  </section>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import Swatch from '@/components/Swatch.vue';
import { CmyColor, CmykColor, RgbColor, HslColor, HsvColor } from '@/models/Color';

@Component({
  components: {
    Swatch,
  },
})
export default class FreeBuild extends Vue {
  private colors: RgbColor[] = [new RgbColor(255, 255, 0), new RgbColor(255, 0, 255)];

  private updateColor(e: MouseEvent) {
    const bounds = (this.$refs.main as HTMLElement).getBoundingClientRect();
    const x = Math.max(0, Math.min(1, (e.clientX - bounds.left) / bounds.width));
    const y = 1 - Math.max(0, Math.min(1, (e.clientY - bounds.top) / bounds.height));

    const hsl = new HslColor(x * 360, 50, y * 100);
    const rgb = hsl.toRgb();
    const hsv = HsvColor.fromRgb(rgb).toRgb();
    const cmy = CmyColor.fromRgb(rgb).toRgb();
    const cmyk = CmykColor.fromRgb(rgb).toRgb();
    this.colors = [hsl.toRgb(), hsv, rgb, cmy, cmyk];

    // console.dir(this.$refs.main);
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
