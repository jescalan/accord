should = require 'should'
path = require 'path'
accord = require '../'
File = require 'fobject'

describe 'coffeescript', ->
  before ->
    @coffee = accord.load('coffee-script')
    @path = path.join(__dirname, 'fixtures', 'coffee')

  it 'should expose name, extensions, output, and engine', ->
    @coffee.extensions.should.be.an.instanceOf(Array)
    @coffee.output.should.be.type('string')
    @coffee.engine.should.be.ok
    @coffee.name.should.be.ok

  it 'should render a string', (done) ->
    @coffee.render('console.log "test"', bare: true).done((res) =>
      should.match_expected(@coffee, res, path.join(@path, 'string.coffee'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.coffee')
    @coffee.renderFile(lpath)
      .done((res) => should.match_expected(@coffee, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @coffee.compile().done(
      ((r) -> should.not.exist(r); done())
      ((r) -> should.exist(r); done())
    )

  it 'should correctly handle errors', (done) ->
    @coffee.render("!   ---@#$$@%#$")
      .done(should.not.exist, (-> done()))

  it 'should generate sourcemaps', (done) ->
    @coffee.render('if true then console.log "test"', bare: true).done (job) ->
      job.text.should.eql('if (true) {\n  console.log("test");\n}\n')
      job.sourceMap.mappings.should.eql(
        'AAAA,IAAG,IAAH;AAAa,EAAA,OAAO,CAAC,GAAR,CAAY,MAAZ,CAAA,CAAb;CAAA'
      )
      done()
