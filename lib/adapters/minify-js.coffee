Adapter = require '../adapter_base'
W = require 'when'
_ = require 'lodash'

class MinifyJS extends Adapter
  constructor: (@compiler) ->
    @name = 'minify-js'
    @extensions = ['js']
    @output = 'js'

  _render: (str, options) ->
    compile => @compiler.minify(str, _.extend(options, { fromString: true })).code

  # private
  
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = MinifyJS
