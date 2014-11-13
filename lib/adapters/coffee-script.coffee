Adapter = require '../adapter_base'
W       = require 'when'

class CoffeeScript extends Adapter
  name: 'coffee-script'
  extensions: ['coffee']
  output: 'js'
  isolated: true
  supportedEngines: ['coffee-script']

  _render: (job, options) ->
    compile => @engine.compile(job.text, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = CoffeeScript
