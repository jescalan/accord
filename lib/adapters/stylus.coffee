Adapter = require '../adapter_base'
W = require 'when'
_ = require 'lodash'

class Stylus extends Adapter

  constructor: (@stylus) ->
    @extensions = ['styl']
    @output = 'css'

  compile: (str, options) ->
    defines = []
    includes = []
    imports = []
    plugins = []

    for k, v of options
      switch k
        when 'define' then defines.push(v)
        when 'include' then includes.push(v)
        when 'import' then imports.push(v)
        when 'use' then plugins.push(v)

    # { foo: 'bar' } => .set('foo', 'bar')
    # { define: { color: 'blue', foo: 'bar'} } => .define('color', 'blue').define('foo', 'bar')
    # { include: 'foo' } => .include('foo')
    # { include: ['foo', 'bar'] } => .include('foo').include('bar')
    # { import: 'foo' } => .import('foo')
    # { import: ['foo', 'bar'] } => .import('foo').import('bar')
    # { use: 'foo' } => .use('foo')
    # { use: ['foo', 'bar'] } => .use('foo').use('bar')

module.exports = Stylus
