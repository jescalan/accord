should = require 'should'
path = require 'path'
accord = require '../'

describe 'markdown', ->
  before ->
    @markdown = accord.load('markdown')
    @path = path.join(__dirname, 'fixtures', 'markdown')

  it 'should expose name, extensions, output, and engine', ->
    @markdown.extensions.should.be.an.instanceOf(Array)
    @markdown.output.should.be.type('string')
    @markdown.engine.should.be.ok
    @markdown.name.should.be.ok

  it 'should render a string', (done) ->
    @markdown.render('hello **world**')
      .done((res) => should.match_expected(@markdown, res, path.join(@path, 'string.md'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.md')
    @markdown.renderFile(lpath)
      .done((res) => should.match_expected(@markdown, res, lpath, done))

  it 'should render with options', (done) ->
    lpath = path.join(@path, 'opts.md')
    @markdown.renderFile(lpath, {sanitize: true})
      .done((res) => should.match_expected(@markdown, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @markdown.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))
