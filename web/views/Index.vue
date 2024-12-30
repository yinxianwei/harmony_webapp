<template>
    <div>
        <van-cell-group inset title="定位">
            <van-cell title="获取定位" is-link @click="getCurrentPosition" />
        </van-cell-group>
        <van-cell-group inset title="极光">
            <van-cell title="初始化" is-link @click="JPushInit" />
            <van-cell title="获取registrationid" is-link @click="JPushGetRegistrationId" />
        </van-cell-group>
        <van-cell-group inset title="http">
            <van-cell title="get请求" is-link @click="sendGet" />
            <van-cell title="post请求" is-link @click="sendPost" />
        </van-cell-group>
    </div>
</template>
<script setup>
import { showDialog, showLoadingToast, closeToast } from 'vant';
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
    window.harmony.JPushInit({ appKey: '16860ec228e1f10d52c11862', channel: 'default', isProduction: true }).then(
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
function sendGet() {
    showLoadingToast({ message: '加载中...', forbidClick: true, duration: 0 });
    window.harmony.request('https://reqres.in/api/users/2', {}).then(
        (res) => {
            closeToast();
            showDialog({ message: res.result });
        },
        (err) => {}
    );
}

function sendPost() {
    showLoadingToast({ message: '加载中...', forbidClick: true, duration: 0 });
    window.harmony
        .request('https://reqres.in/api/users', {
            method: 'POST',
            header: {
                'content-type': 'application/json',
            },
            extraData: {
                name: 'morpheus',
                job: 'leader',
            },
        })
        .then(
            (res) => {
                closeToast();
                showDialog({ message: res.result });
            },
            (err) => {}
        );
}

window.harmony?.addListener('JPushOpenNotification', function (res) {
    showDialog({ message: JSON.stringify(res) });
});
</script>
<style></style>
