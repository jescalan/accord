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

  _render: (str, options) ->
    compile => @engine.compile(str, options).render(options, options.partials)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  _compileClient: (str, options) ->
    options.asString = true
    @_compile(str, options).then((o) -> "new Hogan.Template(#{o.toString()});")

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
