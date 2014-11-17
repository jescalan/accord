Adapter = require '../adapter_base'
W       = require 'when'

class LiveScript extends Adapter
  name: 'LiveScript'
  extensions: ['ls']
  output: 'js'
  isolated: true
  supportedEngines: ['LiveScript']

  _render: (job, options) ->
    W.try(@engine.compile, job.text, options).then(job.setText)

module.exports = LiveScript
