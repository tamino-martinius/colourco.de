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
    <scheme v-if="state.showScheme" :swatches="state.swatches" />
    <legal v-if="state.showLegal" />
    <help v-if="state.showHelp" />
    <navigation />
  </div>

</template>

<script lang="ts">
  import addSwatch from './components/add_swatch';
  import pageTitle from './components/page_title';
  import removeSwatch from './components/remove_swatch';
  import scheme from './components/scheme';
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
        console.log('new Swatch');
      },
      removeSwatch() {
        console.log('new Swatch');
      },
    },
    components: {
      addSwatch,
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
      "title add content remove"\
      "nav   add content remove"\
    ;
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;

    &.mobile {
      grid-template-columns: 50px 1fr 50px;
      grid-template-rows: 50px 1fr 50px;
      grid-template-areas: \
        "add     title   remove"\
        "content content content"\
        "nav     nav     nav"\
      ;
    }
  }
</style>
