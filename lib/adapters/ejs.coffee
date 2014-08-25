path = require 'path'
File = require 'fobject'
W = require 'when'
Adapter = require '../adapter_base'

class EJS extends Adapter
  name: 'ejs'
  extensions: ['ejs']
  output: 'html'
  supportedEngines: ['ejs']

  _render: (str, options) ->
    compile => @engine.render(str, options)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  _compileClient: (str, options) ->
    options.client = true
    compile => @engine.compile(str, options).toString()

  clientHelpers: ->
    new File(path.join(@enginePath, 'ejs.min.js')).read()

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = EJS
