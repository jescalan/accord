Adapter = require '../adapter_base'
_ = require 'lodash'
W = require 'when'
fs = require 'fs'


class Toffee extends Adapter
  constructor: (@compiler) ->
    @name = 'toffee'
    @extensions = ['toffee']
    @output = 'html'

  _render: (str, options) ->
    compiler = _.clone(@compiler)
    compile =>
      compiler.str_render(str, options, (err, res) -> return res)

  _compile: (str, options) ->
    compiler = _.clone(@compiler)
    compile =>
      return compiler.compileStr(str).toString()

  # private
 
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Toffee
