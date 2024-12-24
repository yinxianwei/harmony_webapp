import App from './App.vue';
import { createApp } from 'vue';
import 'vant/lib/index.css';
import vant from 'vant';
import { createPinia } from 'pinia';
import router from './router/index.js';

const app = createApp(App);
const pinia = createPinia();
app.use(pinia);
app.use(vant);
app.use(router);
app.mount('#app');
