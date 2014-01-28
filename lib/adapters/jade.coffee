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
    W.resolve @compiler.render(str, options)

  _compile: (str, options) ->
    W.resolve @compiler.compile(str, options)

  _compileClient: (str, options) ->
    W.resolve @compiler.compileClient(str, options)

  clientHelpers: ->
    runtime_path = path.join(@compiler.__accord_path, 'runtime.js')
    runtime = fs.readFileSync(runtime_path, 'utf8')
    return UglifyJS.minify(runtime, { fromString: true }).code

module.exports = Jade
