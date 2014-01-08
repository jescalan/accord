Adapter = require '../adapter_base'
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
    runtime = @compiler.runtime
    res = "var jade = {"
    Object.keys(runtime).map((f) -> res += "#{f}: #{runtime[f].toString()},")
    return UglifyJS.minify("#{res.slice(0,-1)}}", { fromString: true }).code

module.exports = Jade
