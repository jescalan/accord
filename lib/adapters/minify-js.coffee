Adapter = require '../adapter_base'
W       = require 'when'
_       = require 'lodash'

class MinifyJS extends Adapter
  name: 'minify-js'
  extensions: ['js']
  output: 'js'
  supportedEngines: ['uglify-js']
  isolated: true

  _render: (str, options) ->
    compile => @engine.minify(str, _.extend(options, fromString: true)).code

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(compiled: res)

module.exports = MinifyJS
