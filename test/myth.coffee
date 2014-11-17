should = require 'should'
path = require 'path'
accord = require '../'

describe 'myth', ->
  before ->
    @myth = accord.load('myth')
    @path = path.join(__dirname, 'fixtures', 'myth')

  it 'should expose name, extensions, output, and engine', ->
    @myth.extensions.should.be.an.instanceOf(Array)
    @myth.output.should.be.type('string')
    @myth.engine.should.be.ok
    @myth.name.should.be.ok

  it 'should render a string', (done) ->
    @myth.render(".foo { transition: all 1s ease; }")
      .done((res) => should.match_expected(@myth, res, path.join(@path, 'string.myth'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.myth')
    @myth.renderFile(lpath)
      .done((res) => should.match_expected(@myth, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @myth.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @myth.render("!! ---  )I%$_(I(YRTO")
      .done(should.not.exist, (-> done()))
