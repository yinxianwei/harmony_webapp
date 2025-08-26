<template>
    <van-cell-group inset
                    title="原生交互">
        <van-cell title="接口请求"
                  is-link
                  @click="apiTest()" />
        <van-cell title="获取定位"
                  is-link
                  @click="locationTest()" />
        <van-cell title="打开网页"
                  is-link
                  @click="openUrlTest()" />
        <van-cell title="持久化存储set"
                  is-link
                  @click="setValueTest()" />
        <van-cell title="持久化存储get"
                  is-link
                  @click="getValueTest()" />
        <van-cell title="热更新"
                  is-link
                  @click="updateTest()" />
        <van-cell title="当前版本信息"
                  is-link
                  @click="versionTest()" />
    </van-cell-group>
</template>
<script lang="ts" setup>
import harmony from './harmony';
import { showLoadingToast, closeToast } from 'vant';

function apiTest() {
    showLoadingToast({
        duration: 0,
        message: '加载中...',
        forbidClick: true
    });
    harmony.http
        .request({
            url: 'https://jsonplaceholder.typicode.com/users/1',
            headers: {
                'content-type': 'application/json'
            }
        })
        .then(res => {
            closeToast();
            alert(JSON.stringify(res));
        })
        .catch(err => {
            closeToast();
            alert(JSON.stringify(err));
        });
}

async function locationTest() {
    try {
        let { value } = await harmony.geoLocation.isLocationEnabled();
        if (!value) {
            return alert('未开启定位开关');
        }
    } catch (error) {
        return;
    }
    try {
        let auth = await harmony.geoLocation.requestPermissions();
        if (!auth) {
            return alert('未授权定位权限');
        }
    } catch (error) {
        return;
    }
    try {
        let res = await harmony.geoLocation.getCurrentPosition({ enableHighAccuracy: false, timeout: 5000 });
        alert(`${res.latitude},${res.longitude}`);
    } catch (error) {
        alert(error.message);
        return;
    }
}
function openUrlTest() {
    harmony.browser.openInSystemBrowser({ url: 'https://developer.huawei.com/' });
}
async function setValueTest() {
    await harmony.preference.setValue({ key: 'app', value: Date().toString() });
    alert('success');
}
async function getValueTest() {
    let value = await harmony.preference.getValue({ key: 'app' });
    alert(value);
}
async function updateTest() {
    const toast = showLoadingToast({
        duration: 0,
        forbidClick: true,
        message: '更新中'
    });
    try {
        let version = await harmony.updater.download({
            url: 'https://github.com/yinxianwei/harmony_webapp/archive/refs/tags/1.0.1.zip',
            version: '1.0.1',
            onProgress(receivedSize, totalSize) {
                toast.message = `${receivedSize}/${totalSize}`;
            }
        });
        closeToast();
        await harmony.updater.set(version);
    } catch (error) {
        closeToast();
    }
}
async function versionTest() {
    let webVerison = await harmony.updater.getVersion();
    let { version } = await harmony.updater.appInfo();
    alert(`App版本: ${version}, Web版本: ${webVerison}`);
}
</script>
<style></style>