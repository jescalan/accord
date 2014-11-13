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
    compile => @engine.render(job.text, options)

  _compile: (job, options) ->
    compile => @engine.compile(job.text, options)

  _compileClient: (job, options) ->
    compile => @engine.compileClient(job.text, options)

  clientHelpers: =>
    runtime_path = path.join(@enginePath, 'runtime.js')
    accord.load('minify-js').renderFile(runtime_path)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Jade
