Adapter = require '../adapter_base'
nodefn = require 'when/node/function'
_ = require 'lodash'

class Stylus extends Adapter
  constructor: (@compiler) ->
    @name = 'stylus'
    @extensions = ['styl']
    @output = 'css'

  _render: (str, options) ->
    sets = {}
    defines = {}
    includes = []
    imports = []
    plugins = []

    for k, v of options
      switch k
        when 'define' then _.extend(defines, v)
        when 'include' then includes.push(v)
        when 'import' then imports.push(v)
        when 'use' then plugins.push(v)
        when 'url'
          if typeof v  == 'string'
            obj = {}
            obj[v] = @compiler.url()
            _.extend(defines, obj)
          else
            obj = {}
            obj[v.name] = @compiler.url
              limit: if v.limit? then v.limit else 30000
              paths: v.paths || []
            _.extend(defines, obj)
        else sets[k] = v

    includes = _.flatten(includes)
    imports = _.flatten(imports)
    plugins = _.flatten(plugins)

    base = @compiler(str)

    base.set(k, v) for k, v of sets
    base.define(k, v) for k, v of defines
    base.include(i) for i in includes
    base.import(i) for i in imports
    base.use(i) for i in plugins

    nodefn.call(base.render.bind(base))

module.exports = Stylus
