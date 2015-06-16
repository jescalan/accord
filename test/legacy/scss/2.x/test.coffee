polytest = require('../config')
require = polytest.v2.require()

describe 'scss', ->

  before ->
    @scss = accord.load('scss')
    @path = path.join(__dirname, 'fixtures', 'scss')

  it 'should expose name, extensions, output, and engine', ->
    @scss.extensions.should.be.an.instanceOf(Array)
    @scss.output.should.be.a('string')
    @scss.engine.should.be.ok
    @scss.name.should.be.ok

  it 'should render a string', (done) ->
    @scss.render("$wow: 'red'; foo { bar: $wow; }")
      .done((res) => should.match_expected(@scss, res.result, path.join(@path, 'string.scss'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.scss')
    @scss.renderFile(lpath, { trueDoge: true })
      .done((res) => should.match_expected(@scss, res.result, lpath, done))

  it 'should include external files', (done) ->
    lpath = path.join(@path, 'external.scss')
    @scss.renderFile(lpath, { includePaths: [@path] })
      .done((res) => should.match_expected(@scss, res.result, lpath, done))

  it 'should not be able to compile', (done) ->
    @scss.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @scss.render("!@##%#$#^$")
      .done(should.not.exist, (-> done()))

  it 'should generate a sourcemap', (done) ->
    lpath = path.join(@path, 'basic.scss')
    @scss.renderFile(lpath, { sourcemap: true })
      .tap (res) ->
        res.sourcemap.version.should.equal(3)
        res.sourcemap.mappings.length.should.be.above(1)
        res.sourcemap.sources[0].should.equal(lpath)
        res.sourcemap.sourcesContent.length.should.be.above(0)
      .done((res) => should.match_expected(@scss, res.result, lpath, done))