Adapter = require '../adapter_base'
W = require 'when'
fs = require 'fs'


class Toffee extends Adapter
  constructor: (@compiler) ->
    @name = 'toffee'
    @extensions = ['toffee']
    @output = 'html'

  _render: (str, options) ->
    compile => @compiler.str_render(str, options, (err, res) -> res)

  _compile: (str, options) ->
    compile => @compiler.compileStr(str).toString()

  _compileClient: (str, options) ->
    compile => @compiler.configurable_compile(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Toffee
