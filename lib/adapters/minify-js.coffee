Adapter = require '../adapter_base'
W       = require 'when'
_       = require 'lodash'

class MinifyJS extends Adapter
  name: 'minify-js'
  extensions: ['js']
  output: 'js'
  supportedEngines: ['uglify-js']
  isolated: true

  _render: (job, options) ->
    W.try(@engine.minify, job.text, _.extend(options, fromString: true))
      .then (res) -> job.setText(res.code)

module.exports = MinifyJS
