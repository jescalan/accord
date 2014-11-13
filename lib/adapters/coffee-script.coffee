Adapter = require '../adapter_base'
W       = require 'when'

class CoffeeScript extends Adapter
  name: 'coffee-script'
  extensions: ['coffee']
  output: 'js'
  isolated: true
  supportedEngines: ['coffee-script']

  _render: (job, options) ->
    W.try(@engine.compile, job.text, options)

module.exports = CoffeeScript
