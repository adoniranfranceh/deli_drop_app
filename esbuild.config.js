const esbuild = require('esbuild')
const vuePlugin = require('esbuild-plugin-vue3')

const isWatch = process.argv.includes('--watch')

const buildOptions = {
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  outdir: 'app/assets/builds',
  sourcemap: true,
  format: 'esm',
  publicPath: '/assets',
  plugins: [vuePlugin()],
  loader: {
    '.vue': 'js',
    '.css': 'css',
    '.woff': 'file',
    '.woff2': 'file'
  },
  define: {
    __VUE_OPTIONS_API__: 'true',
    __VUE_PROD_DEVTOOLS__: 'false'
  }
}

async function run() {
  const ctx = await esbuild.context(buildOptions)

  if (isWatch) {
    await ctx.watch()
    console.log('Esbuild is watching for changes...')
  } else {
    await ctx.rebuild()
    ctx.dispose()
  }
}

run().catch(() => process.exit(1))
