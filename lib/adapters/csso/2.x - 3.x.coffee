Adapter = require '../../adapter_base'
W       = require 'when'

class CSSO extends Adapter
  name: 'csso'
  extensions: ['css']
  output: 'css'
  isolated: true

  _render: (str, options) ->
    options.restructuring ?= true
    options.debug ?= false

    compile => @engine.minify(str, options).css

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = CSSO
