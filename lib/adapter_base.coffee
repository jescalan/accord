File    = require 'fobject'
W       = require 'when'
_       = require 'lodash'
resolve = require 'resolve'
path    = require 'path'


class Adapter
  ###*
   * The names of the npm modules that are supported to be used as engines by
     the adapter. Defaults to the name of the adapter.
   * @type {String[]}
  ###
  supportedEngines: undefined

  ###*
   * @param {String} engine The engine to use. Defaults to
     Adapter.supportedEngines[0]
   * @return {[type]} [description]
  ###
  constructor: (@engineName, customPath) ->
    if not @supportedEngines or @supportedEngines.length is 0
      @supportedEngines = [@name]
    if @engineName?
      # a specific engine is required by user
      if @engineName not in @supportedEngines
        throw new Error("engine '#{@engineName}' not supported")
      @engine = requireEngine(@engineName, customPath)
    else
      for @engineName in @supportedEngines
        try
          @engine = requireEngine(@engineName, customPath)
        catch
          continue # try the next one
        return # it worked, we're done
      # nothing in the loop worked, throw an error
      throw new Error("""
        'tried to require: #{@supportedEngines}'.
        None found. Make sure one has been installed!
      """)

  render: (str, opts = {}) ->
    if not @_render
      return W.reject new Error('render not supported')
    @_render(str, opts)

  renderFile: (file, opts = {}) ->
    opts = _.clone(opts, true)
    (new File(file))
      .read(encoding: 'utf8')
      .then _.partialRight(@render, _.extend(opts, {filename: file})).bind(@)

  compile: (str, opts = {}) ->
    if not @_compile
      return W.reject new Error('compile not supported')
    @_compile(str, opts)

  compileFile: (file, opts = {}) ->
    (new File(file))
      .read(encoding: 'utf8')
      .then _.partialRight(@compile, _.extend(opts, {filename: file})).bind(@)

  compileClient: (str, opts = {}) ->
    if not @_compileClient
      return W.reject new Error('client-side compile not supported')
    @_compileClient(str, opts)

  compileFileClient: (file, opts = {}) ->
    (new File(file))
      .read(encoding: 'utf8')
      .then _.partialRight(@compileClient, _.extend(opts, {filename: file})).bind(@)


requireEngine = (engineName, customPath) ->
  if customPath?
    engine = require(resolve.sync(path.basename(customPath), basedir: customPath))
    engine.__accord_path = customPath
  else
    try
      engine = require(engineName)
      engine.__accord_path = resolvePath(engineName)
    catch err
      throw new Error("'#{engineName}' not found. make sure it has been installed!")
  return engine


###*
 * While almost certainly one of the ugliest functions I have written in my
   time, this little utility will get the exact path to the root folder of a
   node module from wherever it would be required from given it's name.
 * @param  {String} name The name of the node module you want the path to.
 * @return {String} The root folder of node module `name`.
 * @private
###
resolvePath = (name) ->
  _path = require.resolve(name).split(path.sep).reverse()
  for p, i in _path
    if _path[i - 1] is name and p is 'node_modules' then break
  _.first(_path.reverse(), _path.length - i + 1).join(path.sep)


module.exports = Adapter
