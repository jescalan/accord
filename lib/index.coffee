W = require 'when'
path = require 'path'
glob = require 'glob'

exports.load = (name, lib) ->
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
  if lib
    compiler = lib
  else
    try
      compiler = require(lib_name)
    catch err
      throw new Error("'#{lib_name}' not found. make sure it has been installed!")

  # patch in the path the compiler was loaded from
  compiler.__accord_path = path.dirname(require.resolve(lib_name))
  # return the adapter with bound compiler
  adapter = new (require(cpath))(compiler)
  return adapter


exports.supports = (name) ->
  !!glob.sync("#{path.join(__dirname, 'adapters', name)}.*").length
