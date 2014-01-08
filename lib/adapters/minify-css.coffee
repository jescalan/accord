Adapter = require '../adapter_base'
W = require 'when'

class MinifyCSS extends Adapter

  constructor: (@compiler) ->
    @name = 'minify-css'
    @extensions = ['css']
    @output = 'css'

  _render: (str, options) ->
    W.resolve (new @compiler(options)).minify(str)

module.exports = MinifyCSS
