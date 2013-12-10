Adapter = require '../adapter_base'
W = require 'when'

class EJS extends Adapter

  constructor: (@compiler) ->
    @name = 'ejs'
    @extensions = ['ejs']
    @output = 'html'

  compile: (str, options) ->
    W.resolve @compiler.render(str, options)

  pre_compile: (str, options) ->
    W.resolve @compiler.compile(str, options)

module.exports = EJS
