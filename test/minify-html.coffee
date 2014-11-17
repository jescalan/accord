should = require 'should'
path = require 'path'
accord = require '../'

describe 'minify-html', ->
  before ->
    @minifyhtml = accord.load('minify-html')
    @path = path.join(__dirname, 'fixtures', 'minify-html')

  it 'should expose name, extensions, output, and engine', ->
    @minifyhtml.extensions.should.be.an.instanceOf(Array)
    @minifyhtml.output.should.be.type('string')
    @minifyhtml.engine.should.be.ok
    @minifyhtml.name.should.be.ok

  it 'should minify a string', (done) ->
    @minifyhtml.render('<div class="hi" id="">\n  <p>hello</p>\n</div>')
      .done((res) => should.match_expected(@minifyhtml, res, path.join(@path, 'string.html'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.html')
    @minifyhtml.renderFile(lpath)
      .catch((err) -> console.log err.stack)
      .done((res) => should.match_expected(@minifyhtml, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.html')
    @minifyhtml.renderFile(lpath, { collapseWhitespace: false })
      .done((res) => should.match_expected(@minifyhtml, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @minifyhtml.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @minifyhtml.render("<<<{@$@#$")
      .done(should.not.exist, (-> done()))
