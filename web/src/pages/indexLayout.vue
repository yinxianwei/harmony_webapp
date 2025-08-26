<template>
    <router-view></router-view>
    <div class="van-safe-area-bottom"
         style="height: var(--van-tabbar-height)"></div>
    <van-tabbar v-model="active">
        <van-tabbar-item v-for="tab in tabs"
                         icon="home-o"
                         :to="{name: tab.key}">{{ tab.name }}</van-tabbar-item>
    </van-tabbar>
</template>
<script lang="ts" setup>
import { ref } from 'vue';
const active = ref(0);
const tabs = [
    {
        name: '首页',
        key: 'index'
    },
    {
        name: '发现',
        key: 'find'
    },
    {
        name: '消息',
        key: 'message'
    },
    {
        name: '我的',
        key: 'me'
    }
];
</script>
<style></style>