File = require 'fobject'
W    = require 'when'
_    = require 'lodash'

class Adapter
  render: (str, opts = {}) ->
    if not @_render
      return W.reject new Error('render not supported')
    @_render(str, opts)

  renderFile: (file, opts = {}) ->
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

module.exports = Adapter
