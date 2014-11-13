Adapter = require '../adapter_base'
W       = require 'when'

class CoffeeScript extends Adapter
  name: 'coffee-script'
  extensions: ['coffee']
  output: 'js'
  isolated: true
  supportedEngines: ['coffee-script']

  constructor: (args...) ->
    super(args...)
    @options.schema.bare =
      type: 'boolean'
      default: false
    @options.schema.header =
      type: 'boolean'
      default: false
    @options.schema.sourceMap =
      type: 'boolean'
      default: true

  _render: (job, options) ->
    options = @options.validate(options)
    W.try(@engine.compile.bind(@engine), job.text, options).then (res) ->
      if typeof res is 'string'
        job.setText(res)
      else
        job.setText(res.js, res.v3SourceMap)

module.exports = CoffeeScript
