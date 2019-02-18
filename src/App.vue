<template>
  <div id="app">
    <div id="nav">
      <router-link v-for="route in routes" :key="route.name" :to="route.path">{{route.name}}</router-link>
    </div>
    <router-view/>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import { routes } from '@/views/Schemes';

@Component
export default class App extends Vue {
  public routes = routes;
}
</script>

<style>
body {
  padding: 0;
  margin: 0;
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
#app {
  display: flex;
  height: 100vh;
}

#nav {
  display: flex;
  flex-direction: column;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
</style>
