import FreeBuild from './FreeBuild.vue';
import Monochrome from './Monochrome.vue';
import { Dictionary } from 'vue-router/types/router';
import { VueConstructor } from 'vue';
import { RouteConfig } from 'vue-router';

export const components: Dictionary<VueConstructor> = {
  FreeBuild,
  Monochrome,
};

export const routes: RouteConfig[] = [];

for (const key in components) {
  if (key && components[key]) {
    const slug = key
      .replace(/([A-Z])/g, '-$1')
      .toLowerCase()
      .substr(1);
    routes.push({
      path: `/${slug}`,
      name: key,
      component: components[key],
    });
  }
}

export default components;
