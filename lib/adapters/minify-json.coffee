W = require 'when'
Adapter = require '../adapter_base'

class MinifyJS extends Adapter
  name: 'minify-json'
  extensions: ['json']
  output: 'json'
  isolated: true

  _render: (job) ->
    try
      res = JSON.stringify(JSON.parse(job.text))
    catch err
      return W.reject(err)
    W.resolve(res)

module.exports = MinifyJS
