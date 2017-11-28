<template>
  <div
    :class="$style.root"
    :style="{
      background: swatch,
    }"
  >
  </div>
</template>

<script lang="ts">
  export default {
    props: [
      'swatch',
      'positions',
    ],
  };
</script>

<style lang="stylus" module>
  .root {
    width: 100%;
    height: 100%;
  }
</style>
