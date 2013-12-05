Adapter = require '../adapter_base'
W = require 'when'

class Jade extends Adapter

  constructor: (@jade) ->

  compile: (str, options) ->
    W.resolve @jade.render(str, options)

  precompile: (str, options) ->
    W.resolve @jade.compile(str, options)    

module.exports = Jade
