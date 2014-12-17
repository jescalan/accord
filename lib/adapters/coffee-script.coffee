Adapter = require '../adapter_base'
W       = require 'when'

class CoffeeScript extends Adapter
  name: 'coffee-script'
  extensions: ['coffee']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    compile => @engine.compile(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    if res.sourceMap
      W.resolve(result: res.js, sourcemap: res.sourceMap, v3sourcemap: res.v3SourceMap)
    else
      W.resolve(result: res)

module.exports = CoffeeScript
