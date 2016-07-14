Adapter    = require '../../adapter_base'
path       = require 'path'
W          = require 'when'
sourcemaps = require '../../sourcemaps'

class Buble extends Adapter
  name: 'buble'
  extensions: ['js']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    options.source = options.filename
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

module.exports = Buble
