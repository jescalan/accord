fs = require 'fs'
W = require 'when'
_ = require 'lodash'

class Adapter
  render: (str, opts = {}) ->
    if not @_render
      return W.reject new Error('render not supported')
    @_render(str, opts)

  renderFile: (file, opts = {}) ->
    @render(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

  compile: (str, opts = {}) ->
    if not @_compile
      return W.reject new Error('compile not supported')
    @_compile(str, opts)

  compileFile: (file, opts = {}) ->
    @compile(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

  compileClient: (str, opts = {}) ->
    if not @_compileClient
      return W.reject new Error('client-side compile not supported')
    @_compileClient(str, opts)

  compileFileClient: (file, opts = {}) ->
    @compileClient(
      fs.readFileSync(file, 'utf8'),
      _.extend(opts, {filename: file})
    )

module.exports = Adapter
