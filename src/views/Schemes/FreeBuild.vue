<template>
  <section>
    <Swatch v-for="(color, index) in colors" :key="index" :color="color" class="swatch"/>
  </section>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import Swatch from '@/components/Swatch.vue';
import { RgbColor } from '@/models/Color';

@Component({
  components: {
    Swatch,
  },
})
export default class FreeBuild extends Vue {
  public colors: RgbColor[] = [new RgbColor(255, 255, 0), new RgbColor(255, 0, 255)];
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
