should = require 'should'
path = require 'path'
accord = require '../'

describe 'less', ->
  before ->
    @less = accord.load('less')
    @path = path.join(__dirname, 'fixtures', 'less')

  it 'should expose name, extensions, output, and engine', ->
    @less.extensions.should.be.an.instanceOf(Array)
    @less.output.should.be.type('string')
    @less.engine.should.be.ok
    @less.name.should.be.ok

  it 'should render a string', (done) ->
    @less.render(".foo { width: 100 + 20 }")
      .done((res) => should.match_expected(@less, res, path.join(@path, 'string.less'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.less')
    @less.renderFile(lpath, { trueDoge: true })
      .done((res) => should.match_expected(@less, res, lpath, done))

  it 'should include external files', (done) ->
    lpath = path.join(@path, 'external.less')
    @less.renderFile(lpath, { paths: [@path] })
      .done((res) => should.match_expected(@less, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @less.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle parse errors', (done) ->
    @less.render("!@##%#$#^$")
      .done(should.not.exist, (-> done()))

  it 'should correctly handle tree resolution errors', (done) ->
    @less.render('''
    .foo {
      .notFound()
    }
    ''')
      .done(should.not.exist, (-> done()))
