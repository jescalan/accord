Adapter = require '../../adapter_base'
W       = require 'when'
_       = require 'lodash'

class EscapeHTML extends Adapter
  name: 'escape-html'
  extensions: ['html']
  output: 'html'
  supportedEngines: ['he']

  isolated: true

  _render: (str, options) ->
    options = _.defaults options,
      allowUnsafeSymbols: true

    compile => @engine.encode(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = EscapeHTML
