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
    compile =>
      res = @engine.minify(str, _.extend(options, fromString: true))
      obj = { compiled: res.code }
      if options.sourceMap then obj.sourcemap = res.map
      obj

  # private

  compile = (fn, map) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = MinifyJS
