should = require 'should'
path = require 'path'
accord = require '../'
fs = require 'fs'
File = require 'fobject'

describe 'minify-json', ->
  before ->
    @minifyjson = accord.load('minify-json')
    @path = path.join(__dirname, 'fixtures', 'minify-json')

  it 'should expose name, extensions, output, and engine', ->
    @minifyjson.extensions.should.be.an.instanceOf(Array)
    @minifyjson.output.should.be.type('string')
    (@minifyjson.engine?).should.be.false
    @minifyjson.name.should.be.ok

  it 'should minify a string', (done) ->
    file = new File(path.join(@path, 'basic.json'))
    file.read(encoding: 'utf8')
      .then @minifyjson.render
      .done((res) =>
        expected = fs.readFileSync(
          path.join(@path, 'expected', 'basic.json'),
          encoding: 'utf8'
        )
        (String res).should.equal(expected)
        done()
      )

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.json')
    @minifyjson.renderFile(lpath).done((res) =>
      expected = fs.readFileSync(
        path.join(@path, 'expected', 'basic.json'),
        encoding: 'utf8'
      )
      (String res).should.equal(expected)
      done()
    )

  it 'should not be able to compile', (done) ->
    @minifyjson.compile().done(
      (r) -> should.not.exist(r); done()
      (r) -> should.exist(r); done()
    )

  it 'should correctly handle errors', (done) ->
    @minifyjson.render("@#$%#I$$N%NI#$%I$PQ")
      .done(should.not.exist, (-> done()))
