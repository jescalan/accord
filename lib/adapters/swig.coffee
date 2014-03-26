Adapter = require '../adapter_base'
path = require 'path'
fs = require 'fs'
W = require 'when'
UglifyJS = require 'uglify-js'

class Swig extends Adapter

  constructor: (@compiler) ->
    @name = 'swig'
    @extensions = ['swig']
    @output = 'html'

  _render: (str, options) ->
    compile => @compiler.render(str, options)

  _compile: (str, options) ->
    compile => @compiler.compile(str, options)

  _compileClient: (str, options) ->
    compile => @compiler.precompile(str, options).tpl.toString()

  renderFile: (path, options = {}) ->
    compile => @compiler.renderFile(path, options.locals)

  compileFile: (path, options = {}) ->
    compile => @compiler.compileFile(path, options)

  clientHelpers: ->
    runtime_path = path.join(@compiler.__accord_path, 'dist/swig.min.js')
    return fs.readFileSync(runtime_path, 'utf8')

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Swig
