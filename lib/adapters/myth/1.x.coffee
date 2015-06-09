Adapter    = require '../../adapter_base'
convert    = require 'convert-source-map'
W          = require 'when'

class Myth extends Adapter
  name: 'myth'
  extensions: ['myth', 'mcss']
  output: 'css'

  _render: (str, options) ->
    options.source = options.filename
    delete options.filename
    compile(options.sourcemap, (=> @engine(str, options)))

  # private

  compile = (sourcemap, fn) ->
    try res = fn()
    catch err then return W.reject(err)

    data = { result: res }

    if sourcemap
      map = convert.fromSource(res).sourcemap
      src = convert.removeComments(res)
      data = { result: src, sourcemap: map }

    return W.resolve(data)

module.exports = Myth
