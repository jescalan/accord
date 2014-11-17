should = require 'should'
path = require 'path'
accord = require '../'

describe 'livescript', ->
  before ->
    @livescript = accord.load('LiveScript')
    @path = path.join(__dirname, 'fixtures', 'livescript')

  it 'should expose name, extensions, output, and engine', ->
    @livescript.extensions.should.be.an.instanceOf(Array)
    @livescript.output.should.be.type('string')
    @livescript.engine.should.be.ok
    @livescript.name.should.be.ok

  it 'should render a string', (done) ->
    @livescript.render("test = ~> console.log('foo')", { bare: true })
      .done((res) => should.match_expected(@livescript, res, path.join(@path, 'string.ls'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.ls')
    @livescript.renderFile(lpath)
      .done((res) => should.match_expected(@livescript, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @livescript.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @livescript.render("!! ---  )I%$_(I(YRTO")
      .done(should.not.exist, (-> done()))
