<template>
  <div :class="$style.root" @click="handleClickEvent">
    -
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
