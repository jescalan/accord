W = require 'when'
Adapter = require '../adapter_base'

class MinifyJS extends Adapter
  name: 'minify-json'
  extensions: ['json']
  output: 'json'
  isolated: true

  _render: (job) ->
    W.try(JSON.parse, job.text).then(JSON.stringify)

module.exports = MinifyJS
