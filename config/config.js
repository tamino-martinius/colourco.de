const { resolve } = require('path');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const webpack = require('webpack');

/// Rules

// Stylus
const stylusRule = {
  test: /\.styl$/,
  use: [
    'style-loader',
    'css-loader',
    'stylus-loader',
  ],
};

// CSS
const cssRule = {
  test: /\.css$/,
  use: [
    'style-loader',
    'css-loader',
  ],
};

// Vue
const vueRule = {
  test: /\.vue$/,
  loader: 'vue-loader',
  options: {
    cssModules: {
      localIdentName: '[path][name]---[local]---[hash:base64:5]',
      camelCase: true,
    },
  },
};

// TypeScript
const tsRule = {
  test: /\.tsx?$/,
  loader: 'ts-loader',
  exclude: /node_modules/,
  options: {
    appendTsSuffixTo: [/\.vue$/],
  },
};

// Images
const imageRule = {
  test: /\.(png|svg|jpg|gif)$/,
  loader: 'file-loader',
  options: {
    name: '[name].[ext]?[hash]'
  },
};

// Fonts
const fontRule = {
  test: /\.(woff|woff2|eot|ttf|otf)$/,
  loader: 'file-loader',
  options: {
    name: '[name].[ext]?[hash]'
  },
};

// CSV
const csvRule = {
  test: /\.(csv|tsv)$/,
  use: [
    'csv-loader',
  ],
};

// XML
const xmlRule = {
  test: /\.xml$/,
  use: [
    'xml-loader',
  ],
};


/// Plugin Options

// CleanWebpackPlugin
const cleanPaths = [
  'dist/*',
];
const cleanOptions = {
  root: resolve('.'),
  exlude: [
    '.keep',
  ],
};

// Runtime Chunk
const runtimeChunkOptions = {
  name: 'runtime',
};

// Vendor Chunk
const vendorChunkOptions = {
  name: 'vendor',
};


/// Export
const config = {
  entry: {
    main: './index.ts',
    vendor: [
      'vue',
    ],
  },
  output: {
    filename: '[name].[chunkhash].js',
    path: resolve('dist'),
  },
  context: resolve('src'),
  performance: {
    hints: false
  },
  devtool: '#eval-source-map',
  module: {
    rules: [
      stylusRule,
      cssRule,
      vueRule,
      imageRule,
      fontRule,
      csvRule,
      xmlRule,
      tsRule,
    ],
  },
  resolve: {
    extensions: ['.ts', '.js', '.vue', '.json'],
    alias: {
      'vue$': 'vue/dist/vue.esm.js',
    },
  },
  plugins: [
    new CleanWebpackPlugin(cleanPaths, cleanOptions),
    // new webpack.HotModuleReplacementPlugin(),
    new webpack.HashedModuleIdsPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new webpack.optimize.CommonsChunkPlugin(vendorChunkOptions),
    new webpack.optimize.CommonsChunkPlugin(runtimeChunkOptions),
  ],
};

module.exports = config;
