Adapter = require '../adapter_base'
W = require 'when'

class Coco extends Adapter

  constructor: (@compiler) ->
    @name = 'coco'
    @extensions = ['co']
    @output = 'js'

  _render: (str, options) ->
    W.resolve @compiler.compile(str, options)

module.exports = Coco
