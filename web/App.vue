<template>
    <van-nav-bar :title="title" :left-arrow="leftArrowVisible" @click-left="clickLeft" />
    <router-view></router-view>
</template>

<script setup>
import { computed } from 'vue';
import { useNavbarStore } from './store/navbar';
import router from './router';

const navbarStore = useNavbarStore();
const title = computed(() => {
    return navbarStore.$state.title;
});
const leftArrowVisible = computed(() => {
    return navbarStore.$state.leftArrowVisible;
});

function clickLeft() {
    router.go(-1);
}
</script>
<style>
body {
    background-color: #f5f5f5;
}
</style>
