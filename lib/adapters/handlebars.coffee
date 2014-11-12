Adapter = require '../adapter_base'
_ = require 'lodash'
path = require 'path'
fs = require 'fs'
W = require 'when'
File = require 'fobject'

class Handlebars extends Adapter
  name: 'handlebars'
  extensions: ['hbs', 'handlebars']
  output: 'html'
  supportedEngines: ['handlebars']

  _render: (str, options) ->
    compiler = _.clone(@engine)
    registerHelpers(compiler, options)
    compile -> compiler.compile(str)(options)

  _compile: (str, options) ->
    compiler = _.clone(@engine)
    registerHelpers(compiler, options)
    compile -> compiler.compile(str)

  _compileClient: (str, options) ->
    compiler = _.clone(@engine)
    registerHelpers(compiler, options)
    compile -> "Handlebars.template(#{compiler.precompile(str)});"

  clientHelpers: ->
    runtimePath = path.join(
      @enginePath,
      'dist/handlebars.runtime.min.js'
    )
    (new File(runtimePath)).read(encoding: 'utf8').then (res) ->
      res.trim() + '\n'

  ###*
   * @private
  ###
  registerHelpers = (compiler, opts) ->
    if opts.helpers
      compiler.helpers = _.merge(compiler.helpers, opts.helpers)
    if opts.partials
      compiler.partials = _.merge(compiler.partials, opts.partials)

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Handlebars
