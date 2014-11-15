W = require 'when'
Adapter = require '../adapter_base'

class InlineSourceMap extends Adapter
  name: 'inline-source-map'
  isolated: true

  constructor: (args...) ->
    super(args...)
    @options.schema.bare =
      type: 'blockComment'
      default: false

  _render: (job, options) ->
    W.try( =>
      options = @options.validate(options)

      # skip if there's no mappings
      if not job.sourceMap.mappings? then return job
      base64 = new Buffer(JSON.stringify(job.sourceMap)).toString('base64')
      text = "# sourceMappingURL=data:application/json;base64,#{base64}"
      if options.blockComment
        text = """
        #{job.text}/*#{text} */\n
        """
      else
        text = "#{job.text}//#{text}\n"
      job.setText(text)
    )

module.exports = InlineSourceMap
