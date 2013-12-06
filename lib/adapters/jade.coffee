Adapter = require '../adapter_base'
W = require 'when'

class Jade extends Adapter

  constructor: (@compiler) ->
    @extensions = ['jade']
    @output = 'html'

  compile: (str, options) ->
    W.resolve @compiler.render(str, options)

  pre_compile: (str, options) ->
    W.resolve @compiler.compile(str, options)    

module.exports = Jade
