Adapter = require '../adapter_base'
W       = require 'when'

class Coco extends Adapter
  name: 'coco'
  extensions: ['co']
  output: 'js'
  isolated: true
  supportedEngines: ['coco']

  constructor: (args...) ->
    super(args...)
    @options.schema.bare =
      type: 'boolean'
      default: false

  _render: (job, options) ->
    options = @options.validate(options)
    compile => @engine.compile(job.text, options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Coco
