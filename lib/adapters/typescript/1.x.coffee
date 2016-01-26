Adapter = require '../../adapter_base'
W       = require 'when'

class TypeScript extends Adapter
  name: 'typescript'
  engineName: 'typescript-compiler'
  supportedEngines: ['typescript-compiler']
  extensions: ['ts']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    throwOnError = (err) -> 
      throw err

    compile => @engine.compileString(str, undefined, options, throwOnError)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = TypeScript
