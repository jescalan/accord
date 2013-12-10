Adapter = require '../adapter_base'
W = require 'when'
_ = require 'lodash'

class MinifyJS extends Adapter

  constructor: (@compiler) ->
    @name = 'minify-js'
    @extensions = ['js']
    @output = 'js'

  compile: (str, options) ->
    W.resolve @compiler.minify(str, _.extend(options, { fromString: true })).code

module.exports = MinifyJS
