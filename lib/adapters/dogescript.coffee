Adapter = require '../adapter_base'
W = require 'when'

class DogeScript extends Adapter
  constructor: (@compiler) ->
    @name = 'dogescript'
    @extensions = ['djs']
    @output = 'js'

  _render: (str, options) ->
    W.resolve @compiler(str, options.beauty, options.trueDoge)

module.exports = DogeScript
