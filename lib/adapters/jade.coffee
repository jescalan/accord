path = require 'path'
W = require 'when'
accord = require '../'
Adapter = require '../adapter_base'

class Jade extends Adapter
  name: 'jade'
  extensions: ['jade']
  output: 'html'
  supportedEngines: ['yade', 'jade']

  _render: (str, options) ->
    compile => @engine.render(str, options)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  _compileClient: (str, options) ->
    compile => @engine.compileClient(str, options)

  clientHelpers: =>
    runtime_path = path.join(@engine.__accord_path, 'runtime.js')
    accord.load('minify-js').renderFile(runtime_path)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = Jade
