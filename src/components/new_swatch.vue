<template>
  <div
    :class="$style.root"
    @click="handleClickEvent"
    @mousemove="handleMoveEvent"
    :style="{
      background: swatch,
    }"
  >
  </div>
</template>

<script lang="ts">
  import Hsl from "../models/hsl";

  export default {
    props: [
      'swatch',
    ],
    methods: {
      handleClickEvent() {
        this.$emit('save');
      },
      handleMoveEvent(e: MouseEvent) {
        const scheme: HTMLElement = this.$el;
        const x = e.offsetX / scheme.clientWidth;
        const y = e.offsetY / scheme.clientHeight;
        this.$emit('change', new Hsl(
          x,
          this.swatch.values[1],
          y,
        ));
      },
    },
  };
</script>

<style lang="stylus" module>
  .root {
    width: 100%;
    height: 100%;
  }
</style>
