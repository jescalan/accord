Adapter    = require '../../adapter_base'
path       = require 'path'
W          = require 'when'
sourcemaps = require '../../sourcemaps'

class SixtoFive extends Adapter
  name: 'babel'
  extensions: ['jsx', 'js']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    filename = options.filename

    if options.sourcemap is true then options.sourceMap = true
    options.sourceMapName = filename
    delete options.sourcemap

    compile => @engine.transform(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)

    data = { result: res.code }
    if res.map
      sourcemaps.inline_sources(res.map).then (map) ->
        data.sourcemap = map
        return data
    else
      W.resolve(data)

module.exports = SixtoFive
