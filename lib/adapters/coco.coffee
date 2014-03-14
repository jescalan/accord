Adapter = require '../adapter_base'
W = require 'when'

class Coco extends Adapter
  constructor: (@compiler) ->
    @name = 'coco'
    @extensions = ['co']
    @output = 'js'

  _render: (str, options) ->
    compile => @compiler.compile(str, options)

  # private
  
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Coco
