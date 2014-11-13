path = require 'path'
File = require 'fobject'
W = require 'when'
Adapter = require '../adapter_base'

class Swig extends Adapter
  name: 'swig'
  extensions: ['swig']
  output: 'html'
  supportedEngines: ['swig']

  _render: (job, options) ->
    compile => @engine.render(job.text, options)

  _compile: (job, options) ->
    compile => @engine.compile(job.text, options)

  _compileClient: (job, options) ->
    compile => @engine.precompile(job.text, options).tpl.toString()

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
