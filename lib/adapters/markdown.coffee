Adapter = require '../adapter_base'
nodefn = require 'when/node/function'

class Markdown extends Adapter
  constructor: (@compiler) ->
    @name = 'markdown'
    @extensions = ['md', 'mdown', 'markdown']
    @output = 'html'

  _render: (str, options) ->
    nodefn.call(@compiler.bind(@compiler), str, options)

module.exports = Markdown
