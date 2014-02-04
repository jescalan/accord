W    = require 'when'
path = require 'path'
glob = require 'glob'
_    = require 'lodash'

exports.load = (name, custom_path) ->
  cpath = path.join(__dirname, 'adapters', name)

  # compiler-specific overrides
  lib_name = switch name
    when 'markdown' then 'marked'
    when 'minify-js' then 'uglify-js'
    when 'minify-css' then 'clean-css'
    when 'minify-html' then 'html-minifier'
    when 'mustache' then 'hogan.js'
    when 'scss' then 'node-sass'
    else name

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
