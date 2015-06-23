Adapter    = require '../../adapter_base'
sourcemaps = require '../../sourcemaps'
W          = require 'when'

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
      obj = {
        result: res.css,
        imports: res.imports
      }
      if options.sourceMap and res.map
        obj.sourcemap = JSON.parse(res.map)
        sourcemaps.inline_sources(obj.sourcemap).then (map) ->
          obj.sourcemap = map
          deferred.resolve(obj)
      else
        deferred.resolve(obj)

    return deferred.promise

module.exports = Less
