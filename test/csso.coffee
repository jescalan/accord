should = require 'should'
path = require 'path'
accord = require '../'

describe 'csso', ->
  before ->
    @csso = accord.load('csso')
    @path = path.join(__dirname, 'fixtures', 'csso')

  it 'should expose name, extensions, output, and engine', ->
    @csso.extensions.should.be.an.instanceOf(Array)
    @csso.output.should.be.type('string')
    @csso.engine.should.be.ok
    @csso.name.should.be.ok

  it 'should minify a string', (done) ->
    @csso.render(".hello { foo: bar; }\n .hello { color: green }")
      .done((res) => should.match_expected(@csso, res, path.join(@path, 'string.css'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.css')
    @csso.renderFile(lpath)
      .done((res) => should.match_expected(@csso, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.css')
    @csso.renderFile(lpath, { noRestructure: true })
      .done((res) => should.match_expected(@csso, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @csso.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @csso.render("wow")
      .done(should.not.exist, (-> done()))
