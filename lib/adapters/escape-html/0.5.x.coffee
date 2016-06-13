Adapter  = require '../../adapter_base'
W        = require 'when'
defaults = require 'lodash.defaults'

class EscapeHTML extends Adapter
  name: 'escape-html'
  extensions: ['html']
  output: 'html'
  supportedEngines: ['he']

  isolated: true

  _render: (str, options) ->
    options = defaults options,
      allowUnsafeSymbols: true

    compile => @engine.encode(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = EscapeHTML
