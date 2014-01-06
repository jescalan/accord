Adapter = require '../adapter_base'
W = require 'when'

class Jade extends Adapter

  constructor: (@compiler) ->
    @name = 'jade'
    @extensions = ['jade']
    @output = 'html'

  _render: (str, options) ->
    W.resolve @compiler.render(str, options)

  _compile: (str, options) ->
    W.resolve @compiler.compile(str, options)

  _compile_client: (str, options) ->
    W.resolve @compiler.compileClient(str, options)

  client_helpers: ->
    runtime = @compiler.runtime
    helpers = Object.keys(runtime).reduce(((m,i) -> m[i] = runtime[i].toString(); m), {})
    return "var jade = #{JSON.stringify(helpers)}"

module.exports = Jade
