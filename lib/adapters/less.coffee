Adapter = require '../adapter_base'
nodefn = require 'when/node/function'

class Less extends Adapter
  name: 'less'
  extensions: ['less']
  output: 'css'
  supportedEngines: ['less']

  ###*
   * LESS has import rules for other LESS stylesheets
  ###
  isolated: false

  _render: (job, options) ->
    nodefn.call(@engine.render, job.text, options).then (res) ->
      job.setText(res.css)

module.exports = Less
