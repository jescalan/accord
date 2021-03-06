Adapter    = require '../../adapter_base'
W          = require 'when'
path       = require 'path'

class SCSS extends Adapter
  name: 'scss'
  extensions: ['scss', 'sass']
  output: 'css'
  supportedEngines: ['node-sass']

  _render: (str, options) ->
    deferred = W.defer()

    if options.sourcemap
      if typeof options.sourcemap is 'string'
        options.sourceMap = options.sourcemap
      else
        options.sourceMap = true
      options.outFile = options.filename.replace('.scss', '.css')
      options.omitSourceMapUrl = true
      options.sourceMapContents = true

    options.file = options.filename
    options.data = str

    @engine.render options, (err, res) ->
      if err then return deferred.reject(err)

      data =
        result: String(res.css),
        imports: res.stats.includedFiles,
        meta:
          entry: res.stats.entry,
          start: res.stats.start,
          end: res.stats.end,
          duration: res.stats.duration

      if res.map
        data.sourcemap = JSON.parse(res.map.toString('utf8'))
        basePath = path.dirname(options.filename)
        if typeof options.sourceMap isnt 'string'
          data.sourcemap.sources =
            data.sourcemap.sources.map (relativePath) ->
              path.join(basePath, relativePath)

      deferred.resolve(data)

    return deferred.promise

module.exports = SCSS
