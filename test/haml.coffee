should = require 'should'
path = require 'path'
accord = require '../'
File = require 'fobject'

describe 'haml', ->
  before ->
    @haml = accord.load('haml')
    @path = path.join(__dirname, 'fixtures', 'haml')

  it 'should expose name, extensions, output, and engine', ->
    @haml.extensions.should.be.an.instanceOf(Array)
    @haml.output.should.be.type('string')
    @haml.engine.should.be.ok
    @haml.name.should.be.ok

  it 'should render a string', (done) ->
    @haml.render('%div.foo= "Whats up " + name', { name: 'mang' })
      .done((res) => should.match_expected(@haml, res, path.join(@path, 'rstring.haml'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.haml')
    @haml.renderFile(lpath, { compiler: 'haml' })
      .done((res) => should.match_expected(@haml, res, lpath, done))

  it 'should compile a string', (done) ->
    @haml.compile('%p= "Hello there " + name').done((res) =>
      should.match_expected(
        @haml
        res(name: 'my friend').trim() + '\n'
        path.join(@path, 'pstring.haml')
        done
      )
    )

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.haml')
    @haml.compileFile(lpath).done((res) =>
      should.match_expected(
        @haml
        res(friend: 'doge').trim() + '\n'
        lpath
        done
      )
    )

  it 'should not support client compiles', (done) ->
    @haml.compileClient("%p= 'Here comes the ' + thing")
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @haml.render("%p= wow()")
      .done(should.not.exist, (-> done()))
