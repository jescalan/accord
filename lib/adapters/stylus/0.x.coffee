Adapter    = require '../../adapter_base'
sourcemaps = require '../../sourcemaps'
nodefn     = require 'when/node/function'
flatten    = require 'lodash.flatten'
assign    = require 'lodash.assign'

class Stylus extends Adapter
  name: 'stylus'
  extensions: ['styl']
  output: 'css'

  _render: (str, options) ->
    sets = {}
    defines = {}
    rawDefines = {}
    includes = []
    imports = []
    plugins = []

    if options.sourcemap is true
      options.sourcemap = { comment: false }

    for k, v of options
      switch k
        when 'define' then assign(defines, v)
        when 'rawDefine' then assign(rawDefines, v)
        when 'include' then includes.push(v)
        when 'import' then imports.push(v)
        when 'use' then plugins.push(v)
        when 'url'
          if typeof v  == 'string'
            obj = {}
            obj[v] = @engine.url()
            assign(defines, obj)
          else
            obj = {}
            obj[v.name] = @engine.url
              limit: if v.limit? then v.limit else 30000
              paths: v.paths || []
            assign(defines, obj)
        else sets[k] = v

    includes = flatten(includes)
    imports = flatten(imports)
    plugins = flatten(plugins)

    base = @engine(str)

    base.set(k, v) for k, v of sets
    base.define(k, v) for k, v of defines
    base.define(k, v, true) for k, v of rawDefines
    base.include(i) for i in includes
    base.import(i) for i in imports
    base.use(i) for i in plugins

    nodefn.call(base.render.bind(base))
      .then (res) ->
        obj = { result: res }
      .then (obj) ->
        if base.sourcemap
          sourcemaps.inline_sources(base.sourcemap).then (map) ->
            obj.sourcemap = map
            obj
        else
          obj

module.exports = Stylus
