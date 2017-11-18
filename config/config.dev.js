const Merge = require('webpack-merge');
const commonConfig = require('./config');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');


/// Rules

/// Plugins

// HTML
const htmlOptions = {
  title: 'colourcode - DEV SERVER',
};


/// Export
const config = Merge(commonConfig, {
  output: {
    pathinfo: true,
  },
  devServer: {
    hot: false,
    port: 3000,
    host: 'localhost',
    historyApiFallback: true,
    noInfo: false,
    contentBase: './dist',
  },
  plugins: [
    new HtmlWebpackPlugin(htmlOptions),
  ],
});

module.exports = config;
