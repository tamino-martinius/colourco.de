<template>
  <div class="free-build">
    <Swatch :color="color"/>
  </div>
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
export default class Monochrome extends Vue {
  public color: RgbColor = new RgbColor(255, 255, 0);
}
</script>
