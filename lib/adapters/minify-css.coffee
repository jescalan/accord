Adapter = require '../adapter_base'
W = require 'when'

class MinifyCSS extends Adapter
  constructor: (@compiler) ->
    @name = 'minify-css'
    @extensions = ['css']
    @output = 'css'

  _render: (str, options) ->
    compile => (new @compiler(options)).minify(str)

  # private
  
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = MinifyCSS
