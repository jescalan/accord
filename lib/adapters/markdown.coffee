Adapter = require '../adapter_base'
nodefn  = require 'when/node/function'

class Markdown extends Adapter
  name: 'markdown'
  extensions: ['md', 'mdown', 'markdown']
  output: 'html'
  supportedEngines: ['marked']
  isolated: true

  _render: (str, options) ->
    nodefn.call(@engine.bind(@engine), str, options)
      .then (res) -> compiled: res

module.exports = Markdown
