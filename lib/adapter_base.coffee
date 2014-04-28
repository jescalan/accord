fs        = require 'fs'
W         = require 'when'
_         = require 'lodash'
nodefn    = require 'when/node'
readFile  = _.partialRight(nodefn.lift(fs.readFile), 'utf8')

class Adapter
  render: (str, opts = {}) ->
    if not @_render
      return W.reject new Error('render not supported')
    @_render(str, opts)

  renderFile: (file, opts = {}) ->
    readFile(file).then _.partialRight(@render, _.extend(opts, {filename: file})).bind(@)

  compile: (str, opts = {}) ->
    if not @_compile
      return W.reject new Error('compile not supported')
    @_compile(str, opts)

  compileFile: (file, opts = {}) ->
    readFile(file).then _.partialRight(@compile, _.extend(opts, {filename: file})).bind(@)

  compileClient: (str, opts = {}) ->
    if not @_compileClient
      return W.reject new Error('client-side compile not supported')
    @_compileClient(str, opts)

  compileFileClient: (file, opts = {}) ->
    readFile(file).then _.partialRight(@compileClient, _.extend(opts, {filename: file})).bind(@)

module.exports = Adapter
