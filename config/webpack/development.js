process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

// @see: http://peter.fitzgibbons.info/2020/05/22/rails-webpack-webpack-manifest-react-babel-7-hmr-chunkhash/
const config = environment.toWebpackConfig();
config.output.filename = "js/[name]-[hash].js"

module.exports = config;
