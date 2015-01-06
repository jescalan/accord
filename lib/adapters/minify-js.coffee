Adapter = require '../adapter_base'
W       = require 'when'
_       = require 'lodash'
path    = require 'path'
convert = require 'convert-source-map'

class MinifyJS extends Adapter
  name: 'minify-js'
  extensions: ['js']
  output: 'js'
  supportedEngines: ['uglify-js']
  isolated: true

  _render: (str, options) ->
    if options.sourcemap is true
      options.sourceMap = true
      options.outSourceMap = path.basename(options.filename)

    compile =>
      res = @engine.minify(str, _.extend(options, fromString: true))
      obj = { result: res.code }

      if options.sourceMap
        obj.sourcemap = JSON.parse(res.map)
        obj.result = convert.removeMapFileComments(obj.result).trim()

      return obj

  # private

  compile = (fn, map) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = MinifyJS
