Adapter    = require '../../adapter_base'
sourcemaps = require '../../sourcemaps'
path       = require 'path'
W          = require 'when'

class JSX extends Adapter
  name: 'jsx'
  extensions: ['jsx']
  output: 'js'
  supportedEngines: ['react-tools']
  isolated: true

  _render: (str, options) ->
    if options.sourcemap is true
      options.sourceMap = true
      options.sourceFilename = options.filename

    compile options, => @engine.transformWithDetails(str, options)

  # private

  compile = (opts, fn) ->
    try res = fn()
    catch err then return W.reject(err)
    if res.sourceMap
      data =
        result: res.code
        sourcemap: res.sourceMap

      # this is an error in the react-tools module
      # https://github.com/facebook/react/issues/3140
      data.sourcemap.sources.pop()
      data.sourcemap.sources.push(opts.filename)

      sourcemaps.inline_sources(data.sourcemap).then (map) ->
        data.sourcemap = map
        return data
    else
      W.resolve(result: res.code)

module.exports = JSX
