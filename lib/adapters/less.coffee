Adapter = require '../adapter_base'
W = require 'when'

class Less extends Adapter
  constructor: (@compiler) ->
    @name = 'less'
    @extensions = ['less']
    @output = 'css'

  _render: (str, options) ->
    deferred = W.defer()

    parser = new @compiler.Parser(options)
    parser.parse str, (err, tree) ->
      if err then return deferred.reject(err)
      deferred.resolve(tree.toCSS())

    return deferred.promise

module.exports = Less
