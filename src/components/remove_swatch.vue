<template>
  <div :class="$style.root" @click="handleEvent">
    -
  </div>
</template>

<script lang="ts">
  export default {
    methods: {
      handleEvent() {
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
