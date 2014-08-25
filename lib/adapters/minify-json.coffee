W = require 'when'
Adapter = require '../adapter_base'

class MinifyJS extends Adapter
  name: 'minify-json'
  extensions: ['json']
  output: 'json'
  isolated: true

  _render: (str) ->
    try
      res = JSON.stringify(JSON.parse(str))
    catch err
      return W.reject(err)
    W.resolve(res)

module.exports = MinifyJS
