Adapter = require '../adapter_base'
W = require 'when'
path = require 'path'
fs = require 'fs'

class EJS extends Adapter

  constructor: (@compiler) ->
    @name = 'ejs'
    @extensions = ['ejs']
    @output = 'html'

  _render: (str, options) ->
    W.resolve @compiler.render(str, options)

  _compile: (str, options) ->
    W.resolve @compiler.compile(str, options)

  _compileClient: (str, options) ->
    options.client = true
    W.resolve @compiler.compile(str, options).toString()

  clientHelpers: (str, options) ->
    runtime_path = path.join(@compiler.__accord_path, '../ejs.min.js')
    return fs.readFileSync(runtime_path, 'utf8')

module.exports = EJS
