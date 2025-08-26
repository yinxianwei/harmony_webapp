import { createRouter, createWebHashHistory } from 'vue-router';
const router = createRouter({
    history: createWebHashHistory(),
    routes: [
        {
            path: '/',
            name: 'home',
            component: () => import('../pages/indexLayout.vue'),
            redirect: '/index',
            children: [
                {
                    path: 'index',
                    name: 'index',
                    component: () => import('../pages/index.vue'),
                    meta: { title: '自定义' }
                }
            ]
        }
    ]
});
router.afterEach((to, from, failure) => {
    if (to.meta?.title) {
    }
});

export default router;
