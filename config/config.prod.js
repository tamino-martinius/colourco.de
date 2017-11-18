const Merge = require('webpack-merge');
const commonConfig = require('./config');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');

/// Rules


/// Plugins

// HTML
const htmlOptions = {
  title: 'colourcode - find your colour scheme',
};

// Minify
var minifyOptions = {
  sourceMap: true,
};


/// Webpack

// Web
const config = Merge(commonConfig, {
  entry: {
    // hmrClient: 'webpack/hot/poll?1000',
  },
  plugins: [
    new HtmlWebpackPlugin(htmlOptions),
    new webpack.optimize.UglifyJsPlugin(minifyOptions),
  ],
});

// Exports
module.exports = config;
