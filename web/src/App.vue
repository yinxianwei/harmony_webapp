<template>
    <van-nav-bar title="标题"
                 :left-arrow="false"
                 @click-left="router.go(-1)"
                 safe-area-inset-top
                 fixed>
    </van-nav-bar>
    <div class="van-safe-area-top"
         style="height: var(--van-nav-bar-height)"></div>
    <router-view></router-view>
</template>
<script setup="ts">
import { useRouter } from 'vue-router';

const router = useRouter();
</script>
<style>
body {
    background-color: #f5f5f5;
}
img {
    max-width: 100%;
}
</style>
