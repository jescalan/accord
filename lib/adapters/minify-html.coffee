Adapter = require '../adapter_base'
W = require 'when'
_ = require 'lodash'

class MinifyHTML extends Adapter
  constructor: (@compiler) ->
    @name = 'minify-html'
    @extensions = ['html']
    @output = 'html'

  _render: (str, options) ->
    options = _.defaults options,
      removeComments: true
      collapseWhitespace: true
      removeEmptyAttributes: true

    compile => @compiler.minify(str, options)

  # private
  
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = MinifyHTML
