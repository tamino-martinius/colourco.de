<template>
  <div :class="$style.root">
    +
  </div>
</template>

<script lang="ts">
  import store from '../models/store';
  import State from '../models/state';

  export default {
    data() {
      return {
        state: <State>store.state,
      };
    },
  };
</script>

<style lang="stylus" module>
  .root {
    grid-area: add;
  }
</style>
