fs = require 'fs'
W = require 'when'
_ = require 'lodash'

class Adapter

  render: (str, opts = {}) ->
    @render(str, opts)

  renderFile: (file, opts = {}) ->
    @render(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

  compile: (str, opts = {}) ->
    @compile(str, opts)

  compileFile: (file, opts = {}) ->
    @compile(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

  compile_client: (file, opts = {}) ->
    if @compile_client
      @compile_client(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))
    else
      W.reject('client compile not supported')

module.exports = Adapter
