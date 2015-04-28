Adapter    = require '../adapter_base'
W          = require 'when'
_          = require 'lodash'
sourcemaps = require '../sourcemaps'

class PostCSS extends Adapter
  name: 'postcss'
  extensions: ['css']
  output: 'css'

  _render: (str, options) ->
    use = options.use ? []
    processor = @engine(use)

    options.map = {inline: false} if options.map is true

    W(processor.process(str, options))
      .then (res) ->
        { result: res.css, sourcemap: res.map }

module.exports = PostCSS
