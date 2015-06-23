Adapter = require '../../adapter_base'
W = require 'when'
fs = require 'fs'

class Toffee extends Adapter
  name: 'toffee'
  extensions: ['toffee']
  output: 'html'
  supportedEngines: ['toffee']

  _render: (str, options) ->
    compile => @engine.str_render(str, options, (err, res) ->
      if res.indexOf("<div style=\"font-family:courier new;font-size:12px;color:#900;width:100%;\">") isnt -1
        throw res
      else res
      )

  _compile: (str, options) ->
    compile => @engine.compileStr(str).toString()

  _compileClient: (str, options) ->
    compile => @engine.configurable_compile(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = Toffee
