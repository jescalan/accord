Adapter = require '../adapter_base'
W       = require 'when'

class CSSO extends Adapter
  name: 'csso'
  extensions: ['css']
  output: 'css'
  isolated: true
  supportedEngines: ['csso']

  _render: (job, options) ->
    options.noRestructure ?= false
    W.try(@engine.justDoIt, job.text, options.noRestructure).then(job.setText)

module.exports = CSSO
