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
    compile =>
      @engine.compile(job.text, options).render(options, options.partials)

  _compile: (job, options) ->
    compile => @engine.compile(job.text, options)

  _compileClient: (job, options) ->
    options.asString = true
    @_compile(job, options).then((o) ->
      "new Hogan.Template(#{o.toString()});"
    )

  clientHelpers: ->
    version = require(path.join(@enginePath, 'package')).version
    runtimePath = path.join(
      @enginePath
      "web/builds/#{version}/hogan-#{version}.min.js"
    )
    (new File(runtimePath)).read(encoding: 'utf8').then (res) ->
      res.trim() + '\n'

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Mustache
