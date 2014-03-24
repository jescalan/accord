Adapter = require '../adapter_base'
_ = require 'lodash'
W = require 'when'
path = require 'path'
fs = require 'fs'

class Nunjucks extends Adapter

  constructor: (@compiler) ->
    @name = 'nunjucks'
    @extensions = ['nunjucks']
    @output = 'html'

  _render: (str, options) ->
    compiler = _.clone(@compiler)
    compiler.configure(path.dirname(options.filename), options)
    compile => compiler.renderString(str, options)

  _compile: (str, options) ->
    compiler = _.clone(@compiler)
    compiler.configure(path.dirname(options.filename), options)
    compile =>
      c = compiler.compile(str, options)
      c.render.bind(c)

  _compileClient: (str, options) ->
    compiler = _.clone(@compiler)
    compiler.configure(path.dirname(options.filename), options)
    compile => compiler.precompileString(str, _.merge(options, {asFunction: true}))

  clientHelpers: ->
    runtime_path = path.join(@compiler.__accord_path, 'browser', 'nunjucks.min.js')
    return fs.readFileSync(runtime_path, 'utf8')

  # private

  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = Nunjucks
