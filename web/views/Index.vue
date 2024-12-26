<template>
    <div>
        <van-cell-group inset title=" ">
            <van-cell title="获取定位" is-link @click="getCurrentPosition" />
        </van-cell-group>
    </div>
</template>
<script setup>
import { showDialog } from 'vant';
function getCurrentPosition() {
    window.harmony.getCurrentPosition(
        (res) => {
            showDialog({ message: JSON.stringify(res) });
        },
        (err) => {
            console.error(err);
        },
        {
            timeout: 5000,
        }
    );
}
</script>
<style></style>
