<template>
  <div :class="$style.root" @click="handleEvent">
    +
  </div>
</template>

<script lang="ts">
  export default {
    methods: {
      handleEvent() {
        this.$emit('add');
      },
    },
  };
</script>

<style lang="stylus" module>
  .root {
    grid-area: add;
  }
</style>
