Adapter = require '../adapter_base'
W = require 'when'

class CoffeeScript extends Adapter
  constructor: (@compiler) ->
    @name = 'coffee-script'
    @extensions = ['coffee']
    @output = 'js'

  _render: (str, options) ->
    compile => @compiler.compile(str, options)

  # private
 
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = CoffeeScript
