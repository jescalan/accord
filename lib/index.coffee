W    = require 'when'
path = require 'path'
glob = require 'glob'
_    = require 'lodash'

exports.load = (name, custom_path) ->
  cpath = path.join(__dirname, 'adapters', name)

  # compiler-specific overrides
  lib_name = name_to_adapter(name)

  # ensure compiler is supported
  if !glob.sync("#{cpath}.*").length then throw new Error('compiler not supported')

  # get the compiler
  if custom_path
    compiler = require(custom_path)
    compiler.__accord_path = custom_path
  else
    try
      compiler = require(lib_name)
      compiler.__accord_path = resolve_path(lib_name)
    catch err
      throw new Error("'#{lib_name}' not found. make sure it has been installed!")

  # return the adapter with bound compiler
  adapter = new (require(cpath))(compiler)
  return adapter


exports.supports = (name) ->
  name = adapter_to_name(name)
  !!glob.sync("#{path.join(__dirname, 'adapters', name)}.*").length

# @api private

# While almost certainly one of the ugliest functions I have written in my time,
# this little utility will get the exact path to the root folder of a node module
# from wherever it would be required from given it's name as a string.
resolve_path = (name) ->
  _path = require.resolve(name).split(path.sep).reverse()
  for p, i in _path
    if _path[i-1] == name && p == 'node_modules' then break
  _.first(_path.reverse(), _path.length - i+1).join(path.sep)

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
    ]

  res = null
  name_maps.forEach (n) ->
    if direction is 'left' and n[0] is name then res = n[1]
    if direction is 'right' and n[1] is name then res = n[0]
  
  return res or name

name_to_adapter = (name) ->
  abstract_mapper(name, 'left')

adapter_to_name = (name) ->
  abstract_mapper(name, 'right')
