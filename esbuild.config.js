const esbuild = require('esbuild');
const vuePlugin = require('esbuild-plugin-vue').default;

const isWatchMode = process.argv.includes('--watch');

const buildOptions = {
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outfile: 'app/assets/builds/application.js',
  plugins: [vuePlugin()],
  define: {
    __VUE_OPTIONS_API__: 'true',
    __VUE_PROD_DEVTOOLS__: 'false',
  },
  sourcemap: true,
};

if (isWatchMode) {
  esbuild.context(buildOptions).then(ctx => {
    ctx.watch();
    console.log('Esbuild is watching for changes...');
  }).catch(() => process.exit(1));
} else {
  esbuild.build(buildOptions).catch(() => process.exit(1));
}
