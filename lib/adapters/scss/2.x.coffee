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

    if options.sourcemap is true
      options.sourceMap = true
      options.outFile = path.basename(options.filename).replace('.scss', '.css')
      options.omitSourceMapUrl = true
      options.sourceMapContents = true

    options.file = options.filename
    options.data = str
    options.error = (err) -> deferred.reject(err)
    options.success = (res) ->
      data =
        result: String(res.css),
        imports: res.stats.includedFiles,
        meta:
          entry: res.stats.entry,
          start: res.stats.start,
          end: res.stats.end,
          duration: res.stats.duration

      if res.map and Object.keys(JSON.parse(res.map)).length
        data.sourcemap = JSON.parse(res.map)
        data.sourcemap.sources.pop()
        data.sourcemap.sources.push(options.file)

      deferred.resolve(data)

    @engine.render(options)

    return deferred.promise

module.exports = SCSS