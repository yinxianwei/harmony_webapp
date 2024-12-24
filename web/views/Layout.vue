<template>
    <div>
        <RouterView />
        <div class="van-safe-area-bottom" style="height: 66px"></div>
        <van-tabbar v-model="active">
            <van-tabbar-item v-for="tab in tabs" icon="home-o" :to="{ name: tab.key }">{{ tab.name }}</van-tabbar-item>
        </van-tabbar>
    </div>
</template>
<script setup>
import { onBeforeUnmount, onMounted, ref, computed } from 'vue';
import { useRoute } from 'vue-router';
import { useNavbarStore } from '../store/navbar';

const active = ref(0);
const tabs = [
    {
        name: '首页',
        key: 'index',
    },
    {
        name: '附近',
        key: 'nearby',
    },
    {
        name: '消息',
        key: 'message',
    },
    {
        name: '我的',
        key: 'me',
    },
];

onMounted(async () => {
    useNavbarStore().setLeftArrowVisible(false);
    active.value = Math.max(
        0,
        tabs.findIndex((tab) => tab.key == useRoute().name)
    );
});
onBeforeUnmount(() => {
    useNavbarStore().setLeftArrowVisible(true);
});
</script>
<style></style>
