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
    W.try(@engine.compile, job.text, options).then(job.setText)

module.exports = Coco
