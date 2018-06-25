// This is an alternative way to define components using decorators
import { Vue, Component, Prop } from 'vue-property-decorator';
import { IconType } from '../types';
import icons from './icons';

@Component({
  template: `
    <component v-bind:is="type"/>
  `,
  components: icons,
})
export default class HelloDecorator extends Vue {
  @Prop() type!: IconType;
}
