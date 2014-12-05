path = require 'path'
glob = require 'glob'
_ = require 'lodash'
indx = require 'indx'
EventEmitter = require('events').EventEmitter

exports.supports = supports = (name) ->
  name = adapter_to_name(name)
  !!glob.sync("#{path.join(__dirname, 'adapters', name)}.*").length

exports.load = (name, enginePath, engineName) ->
  name = adapter_to_name(name)
  return new (require(path.join(__dirname, 'adapters', name)))(engineName, enginePath)

exports.all = ->
  indx(path.join(__dirname, 'adapters'))

###*
 * A map of aliases that we support. Each alias is a key, and the value is the
   real name of the adapter
###
aliasMap =
  'marked': 'markdown'
  'uglify-js': 'minify-js'
  'clean-css': 'minify-css'
  'html-minifier': 'minify-html'
  'hogan.js': 'mustache'
  'node-sass': 'scss'
  'hamljs': 'haml'
  'yade': 'jade'
  'coffee': 'coffee-script'

adapter_to_name = (name) -> aliasMap[name] or name
