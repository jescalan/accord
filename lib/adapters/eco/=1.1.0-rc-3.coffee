Adapter = require '../../adapter_base'
path    = require 'path'
fs      = require 'fs'
W       = require 'when'

class Eco extends Adapter
  name: 'eco'
  extensions: ['eco']
  output: 'html'

  _render: (str,options) ->
    compile => @engine.render(str,options)

  _compile: (str,options) ->
    compile => @engine.compile(str,options)

  _compileClient: (str,options) ->
    compile => @engine.compile(str,options).toString().trim() + '\n'

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = Eco
