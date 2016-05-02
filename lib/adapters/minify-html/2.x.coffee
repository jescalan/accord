Adapter = require '../../adapter_base'
W       = require 'when'
_       = require 'lodash'

class MinifyHTML extends Adapter
  name: 'minify-html'
  extensions: ['html']
  output: 'html'
  supportedEngines: ['html-minifier']

  ###*
   * I think that you could cause this to not be isolated by using the minifyCSS
     option and then making that import stylesheets, but I'm not even sure if
     MinifyHTML would support that...
  ###
  isolated: true

  _render: (str, options) ->
    options = _.defaults options,
      removeComments: true
      collapseWhitespace: true
      removeEmptyAttributes: true

    compile => @engine.minify(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = MinifyHTML
