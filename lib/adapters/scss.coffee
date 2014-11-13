Adapter = require '../adapter_base'
W       = require 'when'

class SCSS extends Adapter
  name: 'css'
  extensions: ['scss']
  output: 'css'
  supportedEngines: ['node-sass']

  _render: (job, options) ->
    deferred = W.defer()

    options.data = job.text
    options.success = deferred.resolve
    options.error = deferred.reject

    @engine.render(options)

    deferred.promise.then(job.setText)

module.exports = SCSS
