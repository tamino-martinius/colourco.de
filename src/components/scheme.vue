<template>
  <div :class="$style.root" @mousemove="move" @click="toggleEdit">
    Scheme
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
    methods: {
      toggleEdit(_e: MouseEvent) {
        this.state.isEditing = !this.state.isEditing;
      },
      move(e: MouseEvent) {
        const scheme: HTMLElement = this.$el;
        const x = e.offsetX / scheme.clientWidth;
        const y = e.offsetY / scheme.clientHeight;
        console.log(x, y);
      },
    },
  };
</script>

<style lang="stylus" module>
  .root {
    grid-area: content;
    background: grey;
  }
</style>
