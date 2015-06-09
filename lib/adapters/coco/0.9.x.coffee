Adapter = require '../../adapter_base'
W       = require 'when'

class Coco extends Adapter
  name: 'coco'
  extensions: ['co']
  output: 'js'
  isolated: true

  _render: (str, options) ->
    compile => @engine.compile(str, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(result: res)

module.exports = Coco
