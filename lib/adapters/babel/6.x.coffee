path       = require 'path'
W          = require 'when'
pick       = require 'lodash.pick'
Adapter    = require '../../adapter_base'
sourcemaps = require '../../sourcemaps'

class Babel extends Adapter
  name: 'babel'
  extensions: ['js', 'jsx']
  output: 'js'
  isolated: true
  supportedEngines: ['babel-core']

  _render: (str, options) ->
    filename = options.filename

    if options.sourcemap is true then options.sourceMaps = true
    options.sourceFileName = filename
    delete options.sourcemap

    # Babel will crash if you pass any keys others than ones they accept in the
    # options object. To be fair, accord should not populate the options object
    # with potentially unused options, or even options that might cause errors
    # as they do here. Eventually this should be fixed up. But to prevent
    # babel-specific breakage, we sanitize the options object here in the
    # meantime.

    allowed_keys = ['filename', 'filenameRelative', 'presets', 'plugins',
    'highlightCode', 'only', 'ignore', 'auxiliaryCommentBefore',
    'auxiliaryCommentAfter', 'sourceMaps', 'inputSourceMap', 'sourceMapTarget',
    'sourceRoot', 'moduleRoot', 'moduleIds', 'moduleId', 'getModuleId',
    'resolveModuleSource', 'code', 'babelrc', 'ast', 'compact', 'comments',
    'shouldPrintComment', 'env', 'retainLines', 'extends']
    sanitized_options = pick(options, allowed_keys)

    compile => @engine.transform(str, sanitized_options)

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)

    data = { result: res.code }
    if res.map
      # Convert source to absolute path.
      # This is done for consistency with other accord adapters.
      if res.map.sources then res.map.sources[0] = res.options.filename

      sourcemaps.inline_sources(res.map).then (map) ->
        data.sourcemap = map
        return data
    else
      W.resolve(data)

module.exports = Babel
