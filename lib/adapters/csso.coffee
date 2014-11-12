Adapter = require '../adapter_base'
W       = require 'when'

class CSSO extends Adapter
  name: 'csso'
  extensions: ['css']
  output: 'css'
  isolated: true
  supportedEngines: ['csso']

  _render: (str, options) ->
    options.noRestructure ?= false
    compile => @engine.justDoIt(str, options.noRestructure)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = CSSO
