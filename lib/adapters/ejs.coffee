path = require 'path'
File = require 'fobject'
W = require 'when'
Adapter = require '../adapter_base'

class EJS extends Adapter
  name: 'ejs'
  extensions: ['ejs']
  output: 'html'

  _render: (str, options) ->
    compile => @engine.render(str, options)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  _compileClient: (str, options) ->
    options.client = true
    compile => @engine.compile(str, options).toString()

  clientHelpers: ->
    new File(path.join(@engine.__accord_path, 'ejs.min.js')).read().then(
      (res) -> result: res
    )

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = EJS
