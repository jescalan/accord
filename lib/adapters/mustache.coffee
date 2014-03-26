Adapter = require '../adapter_base'
W = require 'when'
util = require 'util'
fs = require 'fs'
path = require 'path'

class Mustache extends Adapter
  constructor: (@compiler) ->
    @name = 'mustache'
    @extensions = ['mustache', 'hogan']
    @output = 'html'

  _render: (str, options) ->
    compile => @compiler.compile(str, options).render(options, options.partials)

  _compile: (str, options) ->
    compile => @compiler.compile(str, options)

  _compileClient: (str, options) ->
    options.asString = true
    @_compile(str, options).then((o) -> "new Hogan.Template(#{o.toString()});")

  clientHelpers: ->
    runtime_path = path.join(@compiler.__accord_path, 'web/builds/2.0.0/hogan-2.0.0.min.js')
    return fs.readFileSync(runtime_path, 'utf8')

  # private
  
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Mustache
