Adapter    = require '../../adapter_base'
sourcemaps = require '../../sourcemaps'
path       = require 'path'
W          = require 'when'

class CoffeeScript extends Adapter
  name: 'coffee-script'
  extensions: ['coffee']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    filename = options.filename

    if options.sourcemap is true then options.sourceMap = true
    options.sourceFiles = [filename]
    options.generatedFile = path.basename(filename).replace('.coffee', '.js')

    compile => @engine.compile(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    if res.sourceMap
      data =
        result: res.js
        v2sourcemap: res.sourceMap
        sourcemap: JSON.parse(res.v3SourceMap)
      sourcemaps.inline_sources(data.sourcemap).then (map) ->
        data.sourcemap = map
        return data
    else
      W.resolve(result: res)

module.exports = CoffeeScript
