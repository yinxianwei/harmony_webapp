import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';

function resolve(dir) {
    return path.join(__dirname, dir);
}

export default defineConfig({
    base: './',
    resolve: {
        alias: {
            '@': resolve('src')
        }
    },
    server: {
        host: '0.0.0.0',
        open: true
    },
    build: {
        minify: 'terser',
        target: 'chrome61',
        outDir: '../App/src/main/resources/resfile/dist',
        rollupOptions: {
            output: {
                entryFileNames: 'js/[hash:8].js',
                chunkFileNames: 'js/[hash:8].js',
                assetFileNames(assetInfo) {
                    const names = assetInfo.names || [];

                    if (names.some(name => name.endsWith('.css'))) {
                        return 'css/[hash:8][extname]';
                    }
                    return 'img/[hash:8][extname]';
                }
            }
        }
    },
    plugins: [vue()]
});
