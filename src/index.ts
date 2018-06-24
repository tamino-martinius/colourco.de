import vue from 'vue';
import Hello from './components/Hello';
import HelloDecorator from './components/HelloDecorator';
import HelloVue from './components/Hello.vue';
import HelloDecoratorVue from './components/HelloDecorator.vue';

const v = new vue({
  el: '#app',
  template: `
    <div>
      Name: <input v-model="name" type="text">

      <h1>Hello TS Component</h1>
      <hello :name="name" :initialEnthusiasm="5" />
      <h1>Hello TS Decorator Component</h1>
      <hello-decorator :name="name" :initialEnthusiasm="5" />

      <h1>Hello Vue Component</h1>
      <hello-vue :name="name" :initialEnthusiasm="5" />
      <h1>Hello Vue Decorator Component</h1>
      <hello-decorator-vue :name="name" :initialEnthusiasm="5" />
    </div>
  `,
  data: { name: 'World' },
  components: {
    Hello,
    HelloDecorator,
    HelloVue,
    HelloDecoratorVue,
  },
});
