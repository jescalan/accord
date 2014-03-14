Adapter = require '../adapter_base'
path = require 'path'
fs = require 'fs'
W = require 'when'
UglifyJS = require 'uglify-js'

class Jade extends Adapter
  constructor: (@compiler) ->
    @name = 'jade'
    @extensions = ['jade']
    @output = 'html'

  _render: (str, options) ->
    compile => @compiler.render(str, options)

  _compile: (str, options) ->
    compile => @compiler.compile(str, options)

  _compileClient: (str, options) ->
    compile => @compiler.compileClient(str, options)

  clientHelpers: ->
    runtime_path = path.join(@compiler.__accord_path, 'runtime.js')
    runtime = fs.readFileSync(runtime_path, 'utf8')
    return UglifyJS.minify(runtime, { fromString: true }).code

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Jade
