import './main.styl';
import Vue from 'vue';
import app from './app.vue';

const root = document.createElement('div');
root.id = 'app';
document.body.appendChild(root);

new Vue({
  el: '#app',
  render: display => display(app),
});
