<template>
  <div class="swatch" :style="{'--color': color.toString()}">{{color}}</div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';
import { RgbColor } from '@/models/Color';

@Component
export default class HelloWorld extends Vue {
  @Prop() private color!: RgbColor;

  mounted() {
    console.log(this);
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.swatch {
  background: var(--color);
}
</style>
