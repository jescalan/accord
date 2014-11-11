Adapter = require '../adapter_base'
W       = require 'when'

class Myth extends Adapter
  name: 'myth'
  extensions: ['myth', 'mcss']
  output: 'css'

  _render: (str, options) ->
    options.source = options.filename
    delete options.filename
    compile => @engine(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(compiled: res)

module.exports = Myth
