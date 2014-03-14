Adapter = require '../adapter_base'
W = require 'when'

class SCSS extends Adapter
  constructor: (@compiler) ->
    @name = 'css'
    @extensions = ['scss']
    @output = 'css'

  _render: (str, options) ->
    deferred = W.defer()

    options.data = str
    options.success = deferred.resolve
    options.error = deferred.reject

    @compiler.render(options)

    return deferred.promise

module.exports = SCSS
