path = require 'path'
File = require 'fobject'
W = require 'when'
Adapter = require '../adapter_base'
Job = require '../job'

class Swig extends Adapter
  name: 'swig'
  extensions: ['swig']
  output: 'html'
  supportedEngines: ['swig']

  _render: (job, options) ->
    W.try(@engine.render, job.text, options)
      .then(job.setText)

  _compile: (job, options) ->
    W.try( => @engine.compile(job.text, options))

  _compileClient: (job, options) ->
    W.try( => @engine.precompile(job.text, options).tpl.toString())
      .then(job.setText)

  renderFile: (path, options = {}) ->
    W.try(@engine.renderFile, path, options.locals)
      .then (res) -> new Job(res)
      .then (res) -> res.text.trim() + '\n'

  compileFile: (path, options = {}) ->
    W.try(@engine.compileFile, path, options)

  clientHelpers: ->
    runtime_path = path.join(@enginePath, 'dist/swig.min.js')
    new File(runtime_path).read()

module.exports = Swig
