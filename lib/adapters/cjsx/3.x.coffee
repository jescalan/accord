Adapter    = require '../../adapter_base'
sourcemaps = require '../../sourcemaps'
path       = require 'path'
W          = require 'when'

class CJSX extends Adapter
  name: 'cjsx'
  extensions: ['cjsx']
  output: 'coffee'
  supportedEngines: ['coffee-react-transform']
  isolated: true

  _render: (str, options) ->
    filename = options.filename
    compile => @engine(str)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = CJSX
