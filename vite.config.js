import { defineConfig } from 'vite';

export default defineConfig({
  root: '.',
  build: { outDir: 'dist' },
  server: {
    port: 1420,
    strictPort: true,
    watch: {
      ignored: ['**/src-tauri/**', '**/target/**'],
    },
  },
  clearScreen: false,
});
