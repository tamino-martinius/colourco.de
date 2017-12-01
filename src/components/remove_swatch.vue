<template>
  <div :class="$style.root" @click="handleClickEvent">
    <svg viewBox="0 0 24 24">
      <path d="
        M 14,10
        L 10,10
        L  4,10
        L  4,10
        C  3,10   2,11   2,12
        C  2,13   3,14   4,14
        L 10,14
        L 20,14
        C 21,14  22,13  22,12
        C 22,11  21,10  20,10
        L 14,10
      "></path>
    </svg>
  </div>
</template>

<script lang="ts">
export default {
  methods: {
    handleClickEvent() {
      this.$emit('remove');
    },
  },
};
</script>

<style lang="stylus" module>
  .root {
    grid-area: remove;
  }
</style>
