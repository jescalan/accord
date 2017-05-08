Adapter  = require '../../adapter_base'
path     = require 'path'
fs       = require 'fs'
W        = require 'when'
UglifyJS = require 'uglify-js'

class Pug extends Adapter
  name: 'pug'
  extensions: ['pug']
  output: 'html'
  supportedEngines: ['pug']

  _render: (str, options) ->
    compile => @engine.render(str, options)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  _compileClient: (str, options) ->
    compile => @engine.compileClient(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = Pug
