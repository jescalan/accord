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

  _render: (job, options) ->
    compiler = _.clone(@engine)
    registerHelpers(compiler, options)
    W.try(compiler.compile, job.text).then (res) -> res(options)

  _compile: (job, options) ->
    compiler = _.clone(@engine)
    registerHelpers(compiler, options)
    W.try(compiler.compile, job.text)

  _compileClient: (job, options) ->
    compiler = _.clone(@engine)
    registerHelpers(compiler, options)
    W.try(-> "Handlebars.template(#{compiler.precompile(job.text)});")

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

module.exports = Handlebars
