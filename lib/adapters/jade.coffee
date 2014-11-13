path = require 'path'
W = require 'when'
accord = require '../'
Adapter = require '../adapter_base'

class Jade extends Adapter
  name: 'jade'
  extensions: ['jade']
  output: 'html'
  supportedEngines: ['yade', 'jade']

  _render: (job, options) ->
    W.try(@engine.render, job.text, options).then(job.setText)

  _compile: (job, options) ->
    W.try(@engine.compile, job.text, options)

  _compileClient: (job, options) ->
    W.try(@engine.compileClient, job.text, options).then(job.setText)

  clientHelpers: =>
    runtime_path = path.join(@enginePath, 'runtime.js')
    accord.load('minify-js').renderFile(runtime_path)

module.exports = Jade
