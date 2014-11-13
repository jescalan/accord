path = require 'path'
File = require 'fobject'
W = require 'when'
Adapter = require '../adapter_base'

class EJS extends Adapter
  name: 'ejs'
  extensions: ['ejs']
  output: 'html'
  supportedEngines: ['ejs']

  _render: (job, options) ->
    W.try(@engine.render, job.text, options)

  _compile: (job, options) ->
    W.try(@engine.compile, job.text, options)

  _compileClient: (job, options) ->
    options.client = true
    W.try(@engine.compile,job.text, options).then (res) -> res.toString()

  clientHelpers: ->
    new File(path.join(@enginePath, 'ejs.min.js')).read()

module.exports = EJS
