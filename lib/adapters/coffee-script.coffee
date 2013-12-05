Adapter = require '../adapter_base'
W = require 'when'

class CoffeeScript extends Adapter

  constructor: (@coffee) ->
    @extensions = ['coffee']
    @output = 'js'

  compile: (str, options) ->
    W.resolve @coffee.compile(str, options)

module.exports = CoffeeScript
