W = require 'when'
Adapter = require '../adapter_base'

class MinifyJSON extends Adapter
  name: 'minify-json'
  extensions: ['json']
  output: 'json'
  isolated: true

  _render: (job) ->
    W.try(JSON.parse, job.text).then(JSON.stringify).then(job.setText)

module.exports = MinifyJSON
