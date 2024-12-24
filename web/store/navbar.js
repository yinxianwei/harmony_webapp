import { defineStore } from 'pinia';

export const useNavbarStore = defineStore('navbar', {
    state: () => ({ title: '首页', leftArrowVisible: true }),
    actions: {
        setTitle(title) {
            this.title = title;
        },
        setLeftArrowVisible(visible) {
            this.leftArrowVisible = visible;
        },
    },
});
