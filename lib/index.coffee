path = require 'path'
glob = require 'glob'
_    = require 'lodash'
indx = require 'indx'

exports.supports = supports = (name) ->
  name = adapter_to_name(name)
  !!glob.sync("#{path.join(__dirname, 'adapters', name)}.*").length

exports.load = (name, custom_path) ->
  pkg = name_to_adapter(name)
  name = adapter_to_name(name)

  # ensure compiler is supported
  if not supports(name) then throw new Error("compiler '#{name}' not supported")

  # get the compiler
  if custom_path
    compiler = require(custom_path)
    compiler.__accord_path = custom_path
  else
    try
      compiler = require(pkg)
      compiler.__accord_path = resolve_path(pkg)
    catch err
      throw new Error("'#{pkg}' not found. make sure it has been installed!")

  # return the adapter with bound compiler
  adapter = new (require(path.join(__dirname, 'adapters', name)))(compiler)
  return adapter

exports.all = ->
  indx(path.join(__dirname, 'adapters'))

###*
 * While almost certainly one of the ugliest functions I have written in my
   time, this little utility will get the exact path to the root folder of a
   node module from wherever it would be required from given it's name.
 * @param  {String} name The name of the node module you want the path to.
 * @return {String} The root folder of node module `name`.
 * @private
###

resolve_path = (name) ->
  _path = require.resolve(name).split(path.sep).reverse()
  for p, i in _path
    if _path[i - 1] is name and p is 'node_modules' then break
  _.first(_path.reverse(), _path.length - i + 1).join(path.sep)

# Responsible for mapping between adapters where the language name
# does not match the node module name. direction can be "left" or "right",
# "left" being lang name -> adapter name and right being the opposite.
# 
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
