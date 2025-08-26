export default {
    app: {
        exitApp() {
            return window.harmony.call('app', 'exitApp');
        }
    },
    preference: {
        setValue(options = { key, value }) {
            return window.harmony.call('preference', 'setValue', options);
        },
        getValue(options = { key }) {
            return window.harmony.call('preference', 'getValue', options);
        }
    },
    http: {
        request(options = {}) {
            return window.harmony.call('http', 'request', options);
        }
    },
    updater: {
        appInfo() {
            return window.harmony.call('updater', 'appInfo');
        },
        getVersion() {
            return window.harmony.call('updater', 'getVersion');
        },
        download(options) {
            return window.harmony.call('updater', 'download', options);
        },
        set(options) {
            return window.harmony.call('updater', 'set', options);
        }
    },
    geoLocation: {
        isLocationEnabled() {
            return window.harmony.call('geoLocation', 'isLocationEnabled');
        },
        checkPermissions() {
            return window.harmony.call('geoLocation', 'checkPermissions');
        },
        requestPermissions() {
            return window.harmony.call('geoLocation', 'requestPermissions');
        },
        getCurrentPosition(
            options = {
                enableHighAccuracy: false,
                timeout: 5000
            }
        ) {
            return window.harmony.call('geoLocation', 'getCurrentPosition', options);
        }
    },
    browser: {
        openInSystemBrowser(options = { url }) {
            return window.harmony.call('browser', 'openInSystemBrowser', options);
        }
    }
};
