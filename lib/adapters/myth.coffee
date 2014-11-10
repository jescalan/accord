Adapter = require '../adapter_base'
W       = require 'when'

class Myth extends Adapter
  name: 'myth'
  extensions: ['myth', 'mcss']
  output: 'css'

  _render: (str, options) ->
    compile => @engine(str)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(compiled: res)

module.exports = Myth
