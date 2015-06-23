Adapter  = require '../../adapter_base'
path     = require 'path'
fs       = require 'fs'
W        = require 'when'
UglifyJS = require 'uglify-js'

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

  # clientHelpers: ->
  #   runtime_path = path.join(@engine.__accord_path, 'haml.js')
  #   runtime = fs.readFileSync(runtime_path, 'utf8')
  #   return UglifyJS.minify(runtime, { fromString: true }).code

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = HAML
