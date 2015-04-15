W    = require 'when'
node = require 'when/node'
fs   = require 'fs'

###*
 * Reads a source map's sources and inlines them in the `sourcesContents` key,
 * returning the full map.
 *
 * @param  {Object} map - source map v3
 * @return {Promise} a promise for the sourcemap updated with contents
###

exports.inline_sources = (map) ->
  if map.sourcesContent then return W.resolve(map)

  W.map map.sources, (source) ->
    node.call(fs.readFile.bind(fs), source, 'utf8')
  .then (contents) ->
    map.sourcesContent = contents
    return map
  .catch ->
    # sources could not be read means no inline maps
    return map
