Adapter = require '../adapter_base'
W       = require 'when'

class Myth extends Adapter
  name: 'myth'
  extensions: ['myth', 'mcss']
  output: 'css'
  supportedEngines: ['myth']

  _render: (job, options) ->
    options = @options.validate(options)
    W.try(@engine, job.text)

module.exports = Myth
