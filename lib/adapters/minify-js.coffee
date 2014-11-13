Adapter = require '../adapter_base'
W       = require 'when'
_       = require 'lodash'

class MinifyJS extends Adapter
  name: 'minify-js'
  extensions: ['js']
  output: 'js'
  supportedEngines: ['uglify-js']
  isolated: true

  _render: (job, options) ->
    compile =>
      @engine.minify(job.text, _.extend(options, fromString: true)).code

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = MinifyJS
