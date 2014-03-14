Adapter = require '../adapter_base'
W = require 'when'

class CSSO extends Adapter
  constructor: (@compiler) ->
    @name = 'csso'
    @extensions = ['css']
    @output = 'css'

  _render: (str, options) ->
    options.noRestructure ?= false
    compile => @compiler.justDoIt(str, options.noRestructure)

  # private
  
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = CSSO
