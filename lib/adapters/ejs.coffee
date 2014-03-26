Adapter = require '../adapter_base'
path = require 'path'
fs = require 'fs'
W = require 'when'

class EJS extends Adapter
  constructor: (@compiler) ->
    @name = 'ejs'
    @extensions = ['ejs']
    @output = 'html'

  _render: (str, options) ->
    compile => @compiler.render(str, options)

  _compile: (str, options) ->
    compile => @compiler.compile(str, options)

  _compileClient: (str, options) ->
    options.client = true
    compile => @compiler.compile(str, options).toString()

  clientHelpers: (str, options) ->
    runtime_path = path.join(@compiler.__accord_path, 'ejs.min.js')
    return fs.readFileSync(runtime_path, 'utf8')

  # private
 
  compile = (fn) ->
    try res = fn()
    catch err then return W.reject(err)
    W.resolve(res)

module.exports = EJS
