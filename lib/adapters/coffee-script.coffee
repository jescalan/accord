Adapter = require '../adapter_base'
W = require 'when'

class CoffeeScript extends Adapter

  constructor: (@compiler) ->
    @name = 'coffee-script'
    @extensions = ['coffee']
    @output = 'js'

  compile: (str, options) ->
    W.resolve @compiler.compile(str, options)

module.exports = CoffeeScript
