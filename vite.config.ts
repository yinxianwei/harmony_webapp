import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    base: '',
    root: './web',
    build: {
        outDir: '../app/src/main/resources/rawfile',
        emptyOutDir: true,
    },
    plugins: [vue()],
});
