path    = require 'path'
fs      = require 'fs'
glob    = require 'glob'
_       = require 'lodash'
indx    = require 'indx'
resolve = require 'resolve'
semver  = require 'semver'

exports.supports = supports = (name) ->
  name = adapter_to_name(name)
  !!glob.sync("#{path.join(__dirname, 'adapters', name)}").length

exports.load = (name, custom_path, engine_name) ->
  name = adapter_to_name(name)
  engine_path = resolve_engine_path(name, custom_path)
  version = get_version(engine_path)
  adapter_name = match_version_to_adapter(name, version)

  if not adapter_name
    throw new Error("#{name} version #{version} is not currently supported")

  return new (require(adapter_name))(engine_name, engine_path)

exports.all = ->
  indx(path.join(__dirname, 'adapters'))

# Responsible for mapping between adapters where the language name
# does not match the node module name. direction can be "left" or "right",
# "left" being lang name -> adapter name and right being the opposite.
abstract_mapper = (name, direction) ->
  name_maps = [
    ['markdown', 'marked']
    ['minify-js', 'uglify-js']
    ['minify-css', 'clean-css']
    ['minify-html', 'html-minifier']
    ['mustache', 'hogan.js']
    ['scss', 'node-sass']
    ['haml', 'hamljs']
    ['escape-html', 'he']
    ['jsx', 'react-tools']
    ['cjsx', 'coffee-react-transform']
  ]

  res = null
  name_maps.forEach (n) ->
    if direction is 'left' and n[0] is name then res = n[1]
    if direction is 'right' and n[1] is name then res = n[0]

  return res or name

adapter_to_name = (name) ->
  abstract_mapper(name, 'right')

name_to_adapter = (name) ->
  abstract_mapper(name, 'left')

resolve_engine_path = (name, custom_path) ->
  filepath = if custom_path?
    resolve.sync(name_to_adapter(name), basedir: custom_path)
  else
    require.resolve(name_to_adapter(name))

  loop
    if filepath is '/'
      throw new Error("cannot resolve root of node module #{name}")
    filepath = path.dirname(filepath) # cut off the last part of the path
    if fs.existsSync(path.join filepath, 'package.json')
      # if there's a package.json directly under it, we've found the root of
      # the module
      return filepath

get_version = (engine_path) ->
  try
    require(engine_path + '/package.json').version
  catch err

match_version_to_adapter = (name, version) ->
  adapters = fs.readdirSync(path.join(__dirname, 'adapters', name))
  for adapter in adapters
    adapter = adapter.replace(/\.(?:js|coffee)$/, '')
    if semver.satisfies(version, adapter)
      return path.join(__dirname, 'adapters', name, adapter)
