path = require 'path'
W = require 'when'
# accord = require '../'
Adapter = require '../adapter_base'

# TODO: add doctype and filter opts
# https://github.com/visionmedia/haml.js#extending-haml

class HAML extends Adapter
  name: 'haml'
  extensions: ['haml']
  output: 'html'
  supportedEngines: ['hamljs']

  _render: (job, options) ->
    W.try =>
      job.setText(@engine.compile(job.text)(options))


  _compile: (job, options) ->
    W.try(@engine.compile, job.text, options)

  # client compile not yet supported, but when it is, this will be the path to
  # the right info
  # clientHelpers: ->
  #   runtime_path = path.join(@enginePath, 'haml.js')
  #   accord.load('minify-js').renderFile(runtime_path)

module.exports = HAML
