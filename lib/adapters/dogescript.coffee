Adapter = require '../adapter_base'
W       = require 'when'

class DogeScript extends Adapter
  name: 'dogescript'
  extensions: ['djs']
  output: 'js'

  _render: (str, options) ->
    W.resolve @engine(str, options.beauty, options.trueDoge)

module.exports = DogeScript
