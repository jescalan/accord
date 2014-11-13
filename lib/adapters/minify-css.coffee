Adapter = require '../adapter_base'
W       = require 'when'

class MinifyCSS extends Adapter
  name: 'minify-css'
  extensions: ['css']
  output: 'css'
  supportedEngines: ['clean-css']

  ###*
   * It is sometimes isolated, but not always because you can get it to process
     `import` rules with `processImport`
  ###
  isolated: false

  _render: (job, options) ->
    W.try =>
      job.setText((new @engine(options)).minify(job.text))

module.exports = MinifyCSS
