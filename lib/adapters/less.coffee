Adapter = require '../adapter_base'
W       = require 'when'

class Less extends Adapter
  name: 'less'
  extensions: ['less']
  output: 'css'

  ###*
   * LESS has import rules for other LESS stylesheets
  ###
  isolated: false

  _render: (str, options) ->
    deferred = W.defer()

    if options.sourcemap is true then options.sourceMap = true

    @engine.render str, options, (err, res) ->
      if err then return deferred.reject(err)
      obj = { result: res.css }
      if options.sourceMap then obj.sourcemap = JSON.parse(res.map)
      deferred.resolve(obj)

    return deferred.promise

module.exports = Less
