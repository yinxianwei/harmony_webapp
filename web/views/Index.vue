<template>
    <div>
        <van-cell-group inset title="定位">
            <van-cell title="获取定位" is-link @click="getCurrentPosition" />
        </van-cell-group>
        <van-cell-group inset title="极光">
            <van-cell title="初始化" is-link @click="JPushInit" />
            <van-cell title="获取registrationid" is-link @click="JPushGetRegistrationId" />
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

function JPushInit() {
    window.harmony.JPushInit({ appKey: '', channel: 'default', isProduction: true }).then(
        (res) => {
            showDialog({ message: JSON.stringify(res) });
        },
        (err) => {}
    );
}
function JPushGetRegistrationId() {
    window.harmony.JPushGetRegistrationId().then(
        (res) => {
            showDialog({ message: JSON.stringify(res) });
        },
        (err) => {}
    );
}

window.harmony.addListener('JPushOpenNotification', function (res) {
    showDialog({ message: JSON.stringify(res) });
});
</script>
<style></style>
