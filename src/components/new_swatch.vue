<template>
  <div
    :class="$style.root"
    @click="handleClickEvent"
    @mousemove="handleMoveEvent"
    :style="{
      background: swatch,
    }"
  >
    <svg
      viewBox="0 0 16 16"
      v-for="(position, index) in positions"
      :key="position.toString()"
      :class="[
        $style.marker,
        {
          [$style.activeMarker]: position.isActive
        },
      ]"
      :style="{
        left: `${position.x * 100}%`,
        top: `${position.y * 100}%`,
      }"
    >
      <circle
        :style="{ fill: position.color }"
        cx="8"
        cy="8"
        r="8"
      ></circle>
    </svg>
  </div>
</template>

<script lang="ts">
  import Hsl from "../models/hsl";

  export default {
    props: [
      'swatch',
      'positions',
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
    position: relative;
    width: 100%;
    height: 100%;
    cursor: crosshair;
  }

  .marker {
    pointer-events: none;
    position: absolute;
    width: 8px;
    height: 8px;
    transform: translate(-50%, -50%);
  }

  .active-marker {
    display: none;
  }
</style>
