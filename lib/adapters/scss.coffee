Adapter = require '../adapter_base'
W       = require 'when'

class SCSS extends Adapter
  name: 'css'
  extensions: ['scss']
  output: 'css'
  supportedEngines: ['node-sass']

  _render: (str, options) ->
    deferred = W.defer()

    options.data = str
    options.success = deferred.resolve
    options.error = deferred.reject

    @engine.render(options)

    return deferred.promise

module.exports = SCSS
