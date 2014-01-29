Adapter = require '../adapter_base'
W = require 'when'

class Myth extends Adapter

  constructor: (@compiler) ->
    @name = 'myth'
    @extensions = ['myth', 'mcss']
    @output = 'css'

  _render: (str, options) ->
    W.resolve @compiler(str)

module.exports = Myth
