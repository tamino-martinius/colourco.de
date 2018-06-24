// The default way to create components
import vue from 'vue';

export default vue.extend({
  template: `
    <div>
      <div>Hello {{name}}{{exclamationMarks}}</div>
      <button @click="decrement">-</button>
      <button @click="increment">+</button>
    </div>
  `,
  props: ['name', 'initialEnthusiasm'],
  data() {
    return {
      enthusiasm: this.initialEnthusiasm,
    };
  },
  methods: {
    increment() { this.enthusiasm += 1; },
    decrement() {
      if (this.enthusiasm > 1) {
        this.enthusiasm -= 1;
      }
    },
  },
  computed: {
    exclamationMarks(): string {
      return Array(this.enthusiasm + 1).join('!');
    },
  },
});
