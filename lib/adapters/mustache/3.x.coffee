Adapter = require '../../adapter_base'
W       = require 'when'
util    = require 'util'
fs      = require 'fs'
path    = require 'path'

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
    @_compile(str, options).then((o) -> result: "new Hogan.Template(#{o.result.toString()});")

  clientHelpers: ->
    version = require(path.join(@engine.__accord_path, 'package')).version
    runtime_path = path.join(
      @engine.__accord_path
      "web/builds/#{version}/hogan-#{version}.min.js"
    )
    return fs.readFileSync(runtime_path, 'utf8')

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = Mustache
