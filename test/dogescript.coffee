should = require 'should'
path = require 'path'
accord = require '../'

describe 'dogescript', ->
  before ->
    @doge = accord.load('dogescript')
    @path = path.join(__dirname, 'fixtures', 'dogescript')

  it 'should expose name, extensions, output, and engine', ->
    @doge.extensions.should.be.an.instanceOf(Array)
    @doge.output.should.be.type('string')
    @doge.engine.should.be.ok
    @doge.name.should.be.ok

  it 'should render a string', (done) ->
    @doge.render("console dose loge with 'wow'", { beautify: true })
      .done((res) => should.match_expected(@doge, res, path.join(@path, 'string.djs'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.djs')
    @doge.renderFile(lpath, { trueDoge: true })
      .done((res) => should.match_expected(@doge, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @doge.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  # it turns out that it's impossible for dogescript to throw an error
  # which, honestly, is how it should be. so no test here.
