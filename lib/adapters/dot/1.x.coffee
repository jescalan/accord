Adapter  = require '../../adapter_base'
path     = require 'path'
fs       = require 'fs'
W        = require 'when'

class Dot extends Adapter
  name: 'dot'
  extensions: ['dot']
  output: 'html'

  _render: (str, options) ->
    compile => @engine.compile(str)(options)

  _compile: (str, options) ->
    compile => @engine.compile(str, options)

  _compileClient: (str, options) ->
    options.client = true
    compile =>
      @engine.compile(str, options).toString()

  clientHelpers: (str, options) ->
    runtime_path = path.join(@engine.__accord_path, 'doT.min.js')
    return fs.readFileSync(runtime_path, 'utf8')

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = Dot
