Adapter = require '../adapter_base'
W = require 'when'

class Myth extends Adapter
  constructor: (@compiler) ->
    @name = 'myth'
    @extensions = ['myth', 'mcss']
    @output = 'css'

  _render: (str, options) ->
    compile => @compiler(str)

  # private
  
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Myth
