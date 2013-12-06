should = require 'should'
path = require 'path'
accord = require '../'

describe 'base functions', ->

  it 'supports should work', ->
    accord.supports('jade').should.be.ok
    accord.supports('blargh').should.not.be.ok

  it 'load should work', ->
    (-> accord.load('jade')).should.not.throw
    (-> accord.load('blargh')).should.throw

describe 'jade', ->

  before ->
    @jade = accord.load('jade')
    @path = path.join(__dirname, 'fixtures', 'jade')

  it 'should render a string', ->
    @jade.render('p BLAHHHHH\np= foo', { foo: 'such options' })
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should render a file', ->
    @jade.renderFile(path.join(@path, 'basic.jade'), { foo: 'such options' })
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should precompile a string', ->
    @jade.precompile('p why cant I shot web?\n p= foo')
      .catch(should.not.exist)
      .done (res) -> console.log res({ foo: 'such options' })

  it 'should precompile a file', ->
    @jade.precompileFile(path.join(@path, 'precompile.jade'))
      .catch(should.not.exist)
      .done (res) -> console.log res({ foo: 'such options' })

  it 'should handle external file requests', ->
    @jade.renderFile(path.join(@path, 'partial.jade'))
      .catch(should.not.exist)
      .done (res) -> console.log res

describe 'coffeescript', ->

  before ->
    @coffee = accord.load('coffee-script')
    @path = path.join(__dirname, 'fixtures', 'coffee')

  it 'should render a string', ->
    @coffee.render('console.log "test"', { bare: true })
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should render a file', ->
    @coffee.renderFile(path.join(@path, 'basic.coffee'))
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should not be able to precompile', ->
    @coffee.precompile()
      .done(should.not.exist, should.exist)

# stylus has a heavily modified adapter and a lot of options
# with unique functionality, hence the more robust test suite.

describe 'stylus', ->

  before ->
    @stylus = accord.load('stylus')
    @path = path.join(__dirname, 'fixtures', 'stylus')

  it 'should render a string', ->
    @stylus.render('.test\n  foo: bar')
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should render a file', ->
    @stylus.renderFile(path.join(@path, 'basic.styl'))
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should not be able to precompile', ->
    @stylus.precompile()
      .done(should.not.exist, should.exist)

  it 'should set normal options', ->
    opts =
      paths: ['pluginz']
      foo: 'bar'

    @stylus.renderFile(path.join(@path, 'include1.styl'), opts)
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should set defines', ->
    opts =
      define: { foo: 'bar', baz: 'quux' }
      
    @stylus.render('.test\n  test: foo', opts)
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should set includes', ->
    opts =
      include: 'pluginz'
      
    @stylus.renderFile(path.join(@path, 'include1.styl'), opts)
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should set multiple includes', ->
    opts =
      include: ['pluginz', 'extra_plugin']
      
    @stylus.renderFile(path.join(@path, 'include2.styl'), opts)
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should set imports', ->
    opts =
      import: 'pluginz/lib'
      
    @stylus.renderFile(path.join(@path, 'import1.styl'), opts)
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should set multiple imports', ->
    opts =
      import: ['pluginz/lib', 'pluginz/lib2']
      
    @stylus.renderFile(path.join(@path, 'import2.styl'), opts)
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should set plugins', ->
    opts =
      use: (style) ->
        style.define('main-width', 500)
      
    @stylus.render('.test\n  foo: main-width', opts)
      .catch(should.not.exist)
      .done (res) -> console.log res

  it 'should set multiple plugins', ->
    opts =
      use: [
        ((style) -> style.define('main-width', 500)),
        ((style) -> style.define('main-height', 200)),
      ]
      
    @stylus.render('.test\n  foo: main-width\n  bar: main-height', opts)
      .catch(should.not.exist)
      .done (res) -> console.log res
