should = require 'should'
path = require 'path'
accord = require '../'

describe 'coco', ->
  before ->
    @coco = accord.load('coco')
    @path = path.join(__dirname, 'fixtures', 'coco')

  it 'should expose name, extensions, output, and engine', ->
    @coco.extensions.should.be.an.instanceOf(Array)
    @coco.output.should.be.type('string')
    @coco.engine.should.be.ok
    @coco.name.should.be.ok

  it 'should render a string', (done) ->
    @coco.render("function test\n  console.log('foo')", { bare: true })
      .done((res) => should.match_expected(@coco, res, path.join(@path, 'string.co'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.co')
    @coco.renderFile(lpath)
      .done((res) => should.match_expected(@coco, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @coco.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @coco.render("!! ---  )I%$_(I(YRTO")
      .done(should.not.exist, (-> done()))
