Adapter    = require '../adapter_base'
W          = require 'when'
path       = require 'path'
semver     = require 'semver'

class SCSS extends Adapter
  name: 'scss'
  extensions: ['scss']
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

    # node-sass 1.x needs this
    stats = {}
    options.stats = stats

    successHandler = (res) ->
      # node-sass 1.x compatibility
      if typeof res == 'string'
        res = {
          css: res,
          stats: stats
          map: stats.sourceMap
        }

      data = {
        result: String(res.css),
        imports: res.stats.includedFiles,
        meta: {
          entry: res.stats.entry,
          start: res.stats.start,
          end: res.stats.end,
          duration: res.stats.duration
        }
      }

      if res.map and Object.keys(JSON.parse(res.map)).length
        data.sourcemap = JSON.parse(res.map)
        data.sourcemap.sources.pop()
        data.sourcemap.sources.push(options.file)

      deferred.resolve(data)

    # node-sass 2.x needs handlers in options
    options.error = (err) -> deferred.reject(err)
    options.success = successHandler

    # node-sass 3.x needs handlers as 2nd argument
    @engine.render options, (err, res) ->
      if err then return deferred.reject(err)

      successHandler(res)

    return deferred.promise

module.exports = SCSS
