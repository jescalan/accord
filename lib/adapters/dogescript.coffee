Adapter = require '../adapter_base'
W       = require 'when'

class DogeScript extends Adapter
  name: 'dogescript'
  extensions: ['djs']
  output: 'js'
  isolated: true
  supportedEngines: ['dogescript']

  _render: (job, options) ->
    W.try(@engine, job.text, options.beauty, options.trueDoge).then(job.setText)

module.exports = DogeScript
