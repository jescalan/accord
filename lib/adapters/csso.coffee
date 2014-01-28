Adapter = require '../adapter_base'
W = require 'when'

class CSSO extends Adapter

  constructor: (@compiler) ->
    @name = 'csso'
    @extensions = ['css']
    @output = 'css'

  _render: (str, options) ->
    options.noRestructure ?= false
    W.resolve @compiler.justDoIt(str, options.noRestructure)

module.exports = CSSO
