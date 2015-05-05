Adapter    = require '../adapter_base'
W          = require 'when'
_          = require 'lodash'
path       = require 'path'
convert    = require 'convert-source-map'
sourcemaps = require '../sourcemaps'

class PostCSS extends Adapter
  name: 'postcss'
  extensions: ['css']
  output: 'css'

  _render: (str, options) ->
    use = options.use ? []
    processor = @engine(use)

    if options.map is true
      options.map = {inline: false}
      options.from = options.filename

    W(processor.process(str, options))
      .then (res) ->
        obj = { result: res.css }

        if options.map
          obj.sourcemap = JSON.parse(res.map)
          obj.result = convert.removeMapFileComments(obj.result).trim()
          sourcemaps.inline_sources(obj.sourcemap).then (map) ->
            obj.sourcemap = map
            obj
        else
          obj

module.exports = PostCSS
