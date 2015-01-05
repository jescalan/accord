Adapter = require '../adapter_base'
W       = require 'when'

class CoffeeScript extends Adapter
  name: 'coffee-script'
  extensions: ['coffee']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    filename = options.filename
    options.sourceFiles = [filename]
    options.generatedFile = path.basename(filename).replace('.coffee', '.js')

    compile => @engine.compile(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    if res.sourceMap
      W.resolve
        result: res.js
        old_sourcemap: res.sourceMap
        sourcemap: JSON.parse(res.v3SourceMap)
    else
      W.resolve(result: res)

module.exports = CoffeeScript
