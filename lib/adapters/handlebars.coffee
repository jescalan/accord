Adapter = require '../adapter_base'
_ = require 'lodash'
path = require 'path'
fs = require 'fs'
W = require 'when'

class Handlebars extends Adapter

  constructor: (@compiler) ->
    @name = 'handlebars'
    @extensions = ['hbs', 'handlebars']
    @output = 'html'

  _render: (str, options) ->
    compiler = _.clone(@compiler)
    register_helpers(compiler, options)
    W.resolve compiler.compile(str)(options)

  _compile: (str, options) ->
    compiler = _.clone(@compiler)
    register_helpers(compiler, options)
    W.resolve compiler.compile(str)

  _compileClient: (str, options) ->
    compiler = _.clone(@compiler)
    register_helpers(compiler, options)
    W.resolve "Handlebars.template(#{compiler.precompile(str)});"

  clientHelpers: ->
    runtime_path = path.join(@compiler.__accord_path, 'dist/handlebars.runtime.min.js')
    return fs.readFileSync(runtime_path, 'utf8')

  # @api private
  
  register_helpers = (compiler, opts) ->
    compiler.helpers = _.merge(compiler.helpers, opts.helpers) if opts.helpers
    compiler.partials = _.merge(compiler.partials, opts.partials) if opts.partials

module.exports = Handlebars
