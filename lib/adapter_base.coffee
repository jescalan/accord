fs = require 'fs'
W = require 'when'
_ = require 'lodash'

class Adapter

  render: (str, opts = {}) ->
    if not @_render then return W.reject('render not supported')
    @_render(str, opts)

  renderFile: (file, opts = {}) ->
    @render(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

  compile: (str, opts = {}) ->
    if not @_compile then return W.reject('compile not supported')
    @_compile(str, opts)

  compileFile: (file, opts = {}) ->
    @compile(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

  compile_client: (file, opts = {}) ->
    if not @_compile_client then return W.reject('client-side compile not supported')
    @compile_client(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

module.exports = Adapter
