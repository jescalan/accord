Adapter = require '../adapter_base'
nodefn  = require 'when/node/function'

class Markdown extends Adapter
  name: 'markdown'
  extensions: ['md', 'mdown', 'markdown']
  output: 'html'
  supportedEngines: ['marked']
  isolated: true

  _render: (job, options) ->
    nodefn.call(@engine.bind(@engine), job.text, options).then(job.setText)

module.exports = Markdown
