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

    if semver.satisfies(@engine.version, '0.x || 1.x')
      options.file = options.filename
      options.data = str

      stats = {}

      options.error = (err) -> deferred.reject(err)
      options.success = (res) ->
        data = {
          result: String(res),
          imports: stats.includedFiles,
          meta: {
            entry: stats.entry,
            start: stats.start,
            end: stats.end,
            duration: stats.duration
          }
        }

        deferred.resolve(data)

      @engine.render options

    else if semver.satisfies(@engine.version, '2.x')
      if options.sourcemap is true
        options.sourceMap = true
        options.outFile = path.basename(options.filename).replace('.scss', '.css')
        options.omitSourceMapUrl = true
        options.sourceMapContents = true

      options.file = options.filename
      options.data = str

      options.error = (err) -> deferred.reject(err)
      options.success = (res) ->
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

      @engine.render options

    else
      if options.sourcemap is true
        options.sourceMap = true
        options.outFile = path.basename(options.filename).replace('.scss', '.css')
        options.omitSourceMapUrl = true
        options.sourceMapContents = true

      options.file = options.filename
      options.data = str

      @engine.render options, (err, res) ->
        if err then return deferred.reject(result: res)

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


    return deferred.promise

module.exports = SCSS
