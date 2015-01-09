path = require 'path'
W = require 'when'
# accord = require '../'
Adapter = require '../adapter_base'

# TODO: add doctype and filter opts
# https://github.com/visionmedia/haml.js#extending-haml

class HAML extends Adapter
  name: 'haml'
  extensions: ['haml']
  output: 'html'
  supportedEngines: ['hamljs']

  _render: (str, options) ->
    compile => @engine.compile(str)(options)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  # client compile not yet supported, but when it is, this will be the path to
  # the right info
  # clientHelpers: ->
  #   runtime_path = path.join(@engine.__accord_path, 'haml.js')
  #   accord.load('minify-js').renderFile(runtime_path)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = HAML
