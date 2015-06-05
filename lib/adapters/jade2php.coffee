Adapter    = require '../adapter_base'
convert    = require 'convert-source-map'
W          = require 'when'
_          = require 'lodash'

class JadePHP extends Adapter
  name: 'jade2php'
  extensions: ['jade']
  output: 'php'
  _compile: (str, options) ->
    phpDefaultOptions =
        omitPhpExtractor: yes
        omitPhpRuntime: yes
    compile => (@engine str, _.merge(phpDefaultOptions,options))


  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: -> res)

module.exports = JadePHP
