fs = require 'fs'
W = require 'when'
_ = require 'lodash'

class Adapter

  render: (str, opts) ->
    @compile(str, opts)

  renderFile: (file, opts) ->
    @compile(fs.readFileSync(file), _.extend(opts, {filename: file}))

  precompile: (str, opts) ->
    @precompile(str, opts)

  precompileFile: (file, opts) ->
    @precompile(fs.readFileSync(file), _.extend(opts, {filename: file}))

  compile: ->
    W.reject('make sure you define a compile method')

module.exports = Adapter
