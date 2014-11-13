Adapter = require '../adapter_base'
W       = require 'when'

class LiveScript extends Adapter
  name: 'LiveScript'
  extensions: ['ls']
  output: 'js'
  isolated: true
  supportedEngines: ['LiveScript']

  _render: (job, options) ->
    compile => @engine.compile(job.text, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = LiveScript
