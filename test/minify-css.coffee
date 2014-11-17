should = require 'should'
path = require 'path'
accord = require '../'

describe 'minify-css', ->
  before ->
    @minifycss = accord.load('minify-css')
    @path = path.join(__dirname, 'fixtures', 'minify-css')

  it 'should expose name, extensions, output, and engine', ->
    @minifycss.extensions.should.be.an.instanceOf(Array)
    @minifycss.output.should.be.type('string')
    @minifycss.engine.should.be.ok
    @minifycss.name.should.be.ok

  it 'should minify a string', (done) ->
    @minifycss.render('.test {\n  foo: bar;\n}')
      .done((res) => should.match_expected(@minifycss, res, path.join(@path, 'string.css'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.css')
    @minifycss.renderFile(lpath)
      .done((res) => should.match_expected(@minifycss, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.css')
    @minifycss.renderFile(lpath, { keepBreaks: true })
      .done((res) => should.match_expected(@minifycss, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @minifycss.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @minifycss.render("FMWT$SP#TPO%M@#@#M!@@@")
      .done(should.not.exist, (-> done()))
