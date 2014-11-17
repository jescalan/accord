Adapter = require '../adapter_base'
W = require 'when'
util = require 'util'
fs = require 'fs'
path = require 'path'
File = require 'fobject'

class Mustache extends Adapter
  name: 'mustache'
  extensions: ['mustache', 'hogan']
  output: 'html'
  supportedEngines: ['hogan.js']

  _render: (job, options) ->
    W.try =>
      job.setText(
        @engine.compile(job.text, options).render(options, options.partials)
      )

  _compile: (job, options) ->
    W.try => @engine.compile(job.text, options)

  _compileClient: (job, options) ->
    options.asString = true
    @_compile(job, options).then (res) ->
      job.setText("new Hogan.Template(#{res.toString()});")

  clientHelpers: ->
    version = require(path.join(@enginePath, 'package')).version
    runtimePath = path.join(
      @enginePath
      "web/builds/#{version}/hogan-#{version}.min.js"
    )
    (new File(runtimePath)).read(encoding: 'utf8').then (res) ->
      res.trim() + '\n'

module.exports = Mustache
