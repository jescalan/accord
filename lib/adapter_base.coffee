fs = require 'fs'
W = require 'when'
_ = require 'lodash'

class Adapter

  render: (str, opts = {}) ->
    @compile(str, opts)

  renderFile: (file, opts = {}) ->
    @compile(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))

  precompile: (str, opts = {}) ->
    if @pre_compile
      @pre_compile(str, opts)
    else
      W.reject('precompile not supported')

  precompileFile: (file, opts = {}) ->
    if @pre_compile
      @pre_compile(fs.readFileSync(file, 'utf8'), _.extend(opts, {filename: file}))
    else
      W.reject('precompile not supported')

  compile: ->
    W.reject('make sure you define a compile method')

module.exports = Adapter
