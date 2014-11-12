File = require 'fobject'
W = require 'when'
_ = require 'lodash'
resolve = require 'resolve'
path = require 'path'
fs = require 'fs'
ConfigSchema = require 'config-schema'
accord = require './'


class Adapter
  ###*
   * The names of the npm modules that are supported to be used as engines by
     the adapter. Defaults to the name of the adapter.
   * @type {String[]}
  ###
  supportedEngines: undefined

  ###*
   * The name of the engine in-use. Generally this is the name of the package on
     npm.
   * @type {String}
  ###
  engineName: ''

  ###*
   * The path to the root directory of the engine that's in use.
   * @type {String}
  ###
  enginePath: ''

  ###*
   * The actual engine, no adapter wrapper. Defaults to the engine that we
     recommend for compiling that particular language (if it is installed).
     Otherwise, whatever engine we support that is installed.
  ###
  engine: undefined

  ###*
   * Array of all file extensions the compiler should match
   * @type {String[]}
  ###
  extensions: undefined

  ###*
   * Expected output extension
   * @type {String}
  ###
  output: ''

  ###*
   * Specify if the output of the language is independent of other files or the
     evaluation of potentially stateful functions. This means that the only
     information passed into the engine is what gets passed to Accord's
     compile/render function, and whenever that same input is given, the output
     will always be the same.
   * @type {Boolean}
   * @todo Add detection for when a particular job qualifies as isolated
  ###
  isolated: false

  ###*
   * The schema for options being passed to accord. Making use of this is
     optional, and it assumes that you have basically the same options being
     passed to each function.
  ###
  options: undefined

  ###*
   * @param {String} [engineName=Adapter.supportedEngines[0]] If you need to use a
     particular engine to compile/render with, then specify it here. Otherwise
     we use whatever engine you have installed.
   * @param {String} [enginePath] If you need to use a particular installation
     of an engine (rather than the one that `require` resolves to automatically)
     then pass the path to it here.
  ###
  constructor: (@engineName, @enginePath) ->
    @options = new ConfigSchema()
    @options.schema.filename =
      type: 'string'

    # if the adapter doesn't need an engine
    if not @supportedEngines? then return

    if @engineName?
      # a specific engine is required by user
      if @engineName not in @supportedEngines
        throw new Error("engine '#{@engineName}' not supported")
      @_requireEngine()
    else
      for @engineName in @supportedEngines
        try
          @_requireEngine()
        catch
          continue # try the next one
        return # it worked, we're done
      # nothing in the loop worked, throw an error
      throw new Error("""
        'tried to require: #{@supportedEngines}'.
        None found. Make sure one has been installed!
      """)

  ###*
   * Render a string to a compiled string
   * @param {String} str
   * @param {Object} [opts = {}]
   * @return {Promise}
  ###
  render: (str, opts = {}) =>
    startTime = process.hrtime()
    if not @_render
      return W.reject new Error('render not supported')
    @_render(str, opts)
      .tap( => @emitJobStats(opts.filename, 'render', startTime))
      .then (res) -> res.trim() + '\n'

  ###*
   * Render a file to a compiled string
   * @param {String} file The path to the file
   * @param {Object} [opts = {}]
   * @return {Promise}
  ###
  renderFile: (file, opts = {}) =>
    opts = _.clone(opts, true)
    startTime = process.hrtime()
    (new File(file))
      .read(encoding: 'utf8')
      .then _.partialRight(@render, _.extend(opts, filename: file)).bind(@)
      .tap( => @emitJobStats(opts.filename, 'renderFile', startTime))

  ###*
   * Compile a string to a function
   * @param {String} str
   * @param {Object} [opts = {}]
   * @return {Promise}
  ###
  compile: (str, opts = {}) =>
    startTime = process.hrtime()
    if not @_compile
      return W.reject new Error('compile not supported')
    @_compile(str, opts)
      .tap( => @emitJobStats(opts.filename, 'compile', startTime))

  ###*
   * Compile a file to a function
   * @param {String} file The path to the file
   * @param {Object} [opts = {}]
   * @return {Promise}
  ###
  compileFile: (file, opts = {}) =>
    startTime = process.hrtime()
    (new File(file))
      .read(encoding: 'utf8')
      .then _.partialRight(@compile, _.extend(opts, filename: file)).bind(@)
      .tap( => @emitJobStats(opts.filename, 'compileFile', startTime))

  ###*
   * Compile a string to a client-side-ready function
   * @param {String} str
   * @param {Object} [opts = {}]
   * @return {Promise}
  ###
  compileClient: (str, opts = {}) =>
    startTime = process.hrtime()
    if not @_compileClient
      return W.reject new Error('client-side compile not supported')
    @_compileClient(str, opts)
      .tap( => @emitJobStats(opts.filename, 'compileClient', startTime))
      .then (res) -> res.trim() + '\n'

  ###*
   * Compile a file to a client-side-ready function
   * @param {String} file The path to the file
   * @param {Object} [opts = {}]
   * @return {Promise}
  ###
  compileFileClient: (file, opts = {}) =>
    startTime = process.hrtime()
    (new File(file))
      .read(encoding: 'utf8')
      .then _.partialRight(@compileClient, _.extend(opts, filename: file)).bind(@)
      .tap( => @emitJobStats(opts.filename, 'compileFileClient', startTime))

  ###*
   * Some adapters that compile for client also need helpers, this method
     returns a string of minfied JavaScript with all of them
   * @return {Promise} A promise for the client-side helpers.
  ###
  clientHelpers: undefined

  ###*
   * [emitJobStats description]
   * @param {[type]} filename [description]
   * @param {[type]} method [description]
   * @param {[type]} startTime [description]
   * @param {[type]} deps = [] [description]
   * @param {[type]} isolated = this.isolated [description]
  ###
  emitJobStats: (filename, method, startTime, deps = [], isolated = @isolated) ->
    endTime = process.hrtime(startTime)
    accord.jobLog.emit(
      'jobFinished'
      filename: filename
      engineName: @engineName
      enginePath: @enginePath
      method: method
      duration: endTime[0] + endTime[1] / 1e9
      deps: deps
      isolated: isolated
      time: Date.now()
      pid: process.pid # TODO: move this into accord-parallel
    )

  _requireEngine: ->
    if @enginePath?
      @engine = require(resolve.sync(path.basename(@enginePath), basedir: @enginePath))
    else
      @engine = require(@engineName)
      @enginePath = resolvePath(@engineName)


###*
 * Get the path to the root folder of a node module, given its name.
 * @param  {String} name The name of the node module you want the path to.
 * @return {String} The root folder of node module `name`.
 * @private
###
resolvePath = (name) ->
  filepath = require.resolve(name)
  loop
    if path is '/'
      throw new Error("cannot resolve root of node module #{name}")
    filepath = path.dirname(filepath) # cut off the last part of the path
    if fs.existsSync(path.join filepath, 'package.json')
      # if there's a package.json directly under it, we've found the root of the
      # module
      return filepath

module.exports = Adapter
