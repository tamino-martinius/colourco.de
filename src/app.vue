<template>
  <div :class="[
    $style.app,
    {
      [$style.mobile]: isMobile,
    },
  ]">
    <addSwatch v-if="state.canAdd" @add="newSwatch" />
    <pageTitle />
    <removeSwatch v-if="state.canAdd" @remove="removeSwatch" />
    <scheme v-if="state.showScheme" >
      <div
        v-for="(swatch, index) in state.swatches"
        :is="state.editIndex === index ? 'newSwatch' : 'swatch'"
        :swatch="swatch"
         @save="saveSwatch"
         @change="changeSwatch"
      />
    </scheme>
    <legal v-if="state.showLegal" />
    <help v-if="state.showHelp" />
    <navigation />
  </div>

</template>

<script lang="ts">
  import addSwatch from './components/add_swatch';
  import newSwatch from './components/new_swatch';
  import swatch from './components/swatch';
  import pageTitle from './components/page_title';
  import removeSwatch from './components/remove_swatch';
  import scheme from './components/scheme';
  import Scheme from './models/scheme';
  import Hsl from './models/hsl';
  import legal from './components/legal';
  import help from './components/help';
  import navigation from './components/navigation';
  import store from './models/store';
  import State from './models/state';

  export default {
    data() {
      return {
        state: <State>store.state,
      };
    },
    computed: {
      isMobile: () =>
        (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))
    },
    methods: {
      newSwatch() {
        console.log('add');
        this.state.swatches.push(Scheme.randomPastelColor);
        this.state.editIndex = this.state.swatches.length - 1;
      },
      removeSwatch() {
        console.log('remove');
        this.state.swatches.pop();
          if (this.state.swatches.length === 0) {
          this.newSwatch();
        }
      },
      saveSwatch() {
        console.log('save');
        this.state.editIndex = undefined;
      },
      changeSwatch(hsl: Hsl) {
        this.state.swatches.splice(this.state.editIndex, 1, hsl);
      },
    },
    components: {
      addSwatch,
      newSwatch,
      swatch,
      pageTitle,
      removeSwatch,
      navigation,
      scheme,
      legal,
      help,
    },
  };
</script>

<style module lang="stylus">
  .app {
    display: grid;
    width: 100%;
    height: 100%;
    grid-template-columns 50px 50px 1fr 50px;
    grid-template-rows: 50px 1fr;
    grid-template-areas: \
      "title remove content add"\
      "nav   remove content add"\
    ;
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;

    &.mobile {
      grid-template-columns: 50px 1fr 50px;
      grid-template-rows: 50px 1fr 50px;
      grid-template-areas: \
        "remove  title   add"\
        "content content content"\
        "nav     nav     nav"\
      ;
    }
  }
</style>
