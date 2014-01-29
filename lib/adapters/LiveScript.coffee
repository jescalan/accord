Adapter = require '../adapter_base'
W = require 'when'

class LiveScript extends Adapter

  constructor: (@compiler) ->
    @name = 'LiveScript'
    @extensions = ['ls']
    @output = 'js'

  _render: (str, options) ->
    W.resolve @compiler.compile(str, options)

module.exports = LiveScript
