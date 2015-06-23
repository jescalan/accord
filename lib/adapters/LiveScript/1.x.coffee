Adapter = require '../../adapter_base'
W       = require 'when'

class LiveScript extends Adapter
  name: 'LiveScript'
  extensions: ['ls']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    compile => @engine.compile(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = LiveScript
