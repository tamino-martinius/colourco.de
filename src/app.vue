<template>
  <div :class="[
    $style.app,
    {
      [$style.mobile]: isMobile,
      [$style.showAdd]: state.canAdd,
      [$style.showRemove]: state.canRemove,
    },
  ]">
    <AddSwatch v-if="state.canAdd" @add="newSwatch" />
    <PageTitle />
    <RemoveSwatch v-if="state.canRemove" @remove="removeSwatch" />
    <Scheme v-if="state.showScheme" >
      <div
        :key="`swatch-${index}`"
        v-for="(swatch, index) in state.swatches"
        :is="state.editIndex === index ? 'newSwatch' : 'swatch'"
        :swatch="swatch"
        :positions="state.positions"
        @save="saveSwatch"
        @change="changeSwatch"
      />
    </Scheme>
    <Legal v-if="state.showLegal" />
    <Help v-if="state.showHelp" />
    <Navigation @changeScheme="changeScheme" />
  </div>

</template>

<script lang="ts">
  import AddSwatch from './components/add_swatch.vue';
  import NewSwatch from './components/new_swatch.vue';
  import Swatch from './components/swatch.vue';
  import PageTitle from './components/page_title.vue';
  import RemoveSwatch from './components/remove_swatch.vue';
  import Scheme from './components/scheme.vue';
  import Legal from './components/legal.vue';
  import Help from './components/help.vue';
  import Navigation from './components/navigation.vue';

import SchemeGenerator, { SchemeName } from './models/scheme';
  import Hsl from './models/hsl';
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
        this.state.swatches.push(SchemeGenerator.randomPastelColor);
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
      changeScheme(scheme: SchemeName) {
        console.log('change scheme', scheme);
      },
    },
    components: {
      AddSwatch,
      NewSwatch,
      Swatch,
      PageTitle,
      RemoveSwatch,
      Navigation,
      Scheme,
      Legal,
      Help,
    },
  };
</script>

<style module lang="stylus">
  .app {
    display: grid;
    width: 100%;
    height: 100%;
    grid-template-columns 50px 0 1fr 0;
    grid-template-rows: 50px 1fr;
    grid-template-areas: \
      "title remove content add"\
      "nav   remove content add"\
    ;
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;

    &.show-remove {
      grid-template-columns 50px 50px 1fr 0;
    }

    &.show-add.show-remove {
      grid-template-columns 50px 50px 1fr 50px;
    }

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
