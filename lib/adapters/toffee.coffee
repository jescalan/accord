Adapter = require '../adapter_base'
W = require 'when'
fs = require 'fs'


class Toffee extends Adapter
  name: 'toffee'
  extensions: ['toffee']
  output: 'html'
  supportedEngines: ['toffee']

  _render: (job, options) ->
    W.try =>
      @engine.str_render(job.text, options, (err, res) ->
        errorText = '<div style="font-family:courier
        new;font-size:12px;color:#900;width:100%;">'
        if res.indexOf(errorText) isnt -1
          throw res
        else
          job.setText res
      )

  _compile: (job, options) ->
    W.try => @engine.compileStr(job.text).toString()

  _compileClient: (job, options) ->
    W.try => job.setText @engine.configurable_compile(job.text, options)

module.exports = Toffee
