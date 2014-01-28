Adapter = require '../adapter_base'
W = require 'when'

class Mustache extends Adapter

  constructor: (@compiler) ->
    @name = 'mustache'
    @extensions = ['mustache', 'hogan']
    @output = 'html'

  _render: (str, options) ->
    W.resolve @compiler.compile(str, options).render(options, options.partials)

  _compile: (str, options) ->
    W.resolve @compiler.compile(str, options)

  _compileClient: @::_compile

  # hogan does not need any additional client helpers

module.exports = Mustache
