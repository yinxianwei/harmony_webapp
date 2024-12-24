import { createRouter, createWebHashHistory } from 'vue-router';
import Layout from '../views/Layout.vue';
import Index from '../views/Index.vue';
import Nearby from '../views/Nearby.vue';
import Message from '../views/Message.vue';
import Me from '../views/Me.vue';
import SignIn from '../views/SignIn.vue';
import { useNavbarStore } from '../store/navbar';
const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/',
            name: 'layout',
            component: Layout,
            redirect: '/index',
            children: [
                {
                    path: 'index',
                    name: 'index',
                    component: Index,
                    meta: { title: '首页' },
                },
                {
                    path: 'nearby',
                    name: 'nearby',
                    component: Nearby,
                    meta: { title: '附近' },
                },
                {
                    path: 'message',
                    name: 'message',
                    component: Message,
                    meta: { title: '消息' },
                },
                {
                    path: 'me',
                    name: 'me',
                    component: Me,
                    meta: { title: '我的' },
                },
            ],
        },
        {
            path: '/signin',
            name: 'signin',
            component: SignIn,
            meta: { title: '登录' },
        },
    ],
});
router.afterEach((to, from, failure) => {
    if (to.meta?.title) {
        useNavbarStore().setTitle(to.meta.title);
    }
});

export default router;
