should = require 'should'
path = require 'path'
accord = require '../'

describe 'scss', ->
  before ->
    @scss = accord.load('scss')
    @path = path.join(__dirname, 'fixtures', 'scss')

  it 'should expose name, extensions, output, and engine', ->
    @scss.extensions.should.be.an.instanceOf(Array)
    @scss.output.should.be.type('string')
    @scss.engine.should.be.ok
    @scss.name.should.be.ok

  it 'should render a string', (done) ->
    @scss.render("$wow: 'red'; foo { bar: $wow; }")
      .done((res) => should.match_expected(@scss, res, path.join(@path, 'string.scss'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.scss')
    @scss.renderFile(lpath, { trueDoge: true })
      .done((res) => should.match_expected(@scss, res, lpath, done))

  it 'should include external files', (done) ->
    lpath = path.join(@path, 'external.scss')
    @scss.renderFile(lpath, { includePaths: [@path] })
      .done((res) => should.match_expected(@scss, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @scss.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @scss.render("!@##%#$#^$")
      .done(should.not.exist, (-> done()))
