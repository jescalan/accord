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
    compile => @engine.render(job.text, options)

  _compile: (job, options) ->
    compile => @engine.compile(job.text, options)

  _compileClient: (job, options) ->
    options.client = true
    compile => @engine.compile(job.text, options).toString()

  clientHelpers: ->
    new File(path.join(@enginePath, 'ejs.min.js')).read()

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = EJS
