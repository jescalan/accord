path = require 'path'
File = require 'fobject'
W = require 'when'
Adapter = require '../adapter_base'

class Swig extends Adapter
  name: 'swig'
  extensions: ['swig']
  output: 'html'
  supportedEngines: ['swig']

  _render: (str, options) ->
    compile => @engine.render(str, options)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  _compileClient: (str, options) ->
    compile => @engine.precompile(str, options).tpl.toString()

  renderFile: (path, options = {}) ->
    compile => @engine.renderFile(path, options.locals)
      .then((res) -> res.trim() + '\n')

  compileFile: (path, options = {}) ->
    compile(=> @engine.compileFile(path, options))

  clientHelpers: ->
    runtime_path = path.join(@enginePath, 'dist/swig.min.js')
    new File(runtime_path).read()

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Swig
