Adapter = require '../adapter_base'
W       = require 'when'

class Less extends Adapter
  name: 'less'
  extensions: ['less']
  output: 'css'
  supportedEngines: ['less']

  ###*
   * LESS has import rules for other LESS stylesheets
  ###
  isolated: false

  _render: (job, options) ->
    deferred = W.defer()

    @engine.render job.text, options, (err, res) ->
      if err then return deferred.reject(err)
      deferred.resolve(res.css)

    return deferred.promise

module.exports = Less
