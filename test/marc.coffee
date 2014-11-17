should = require 'should'
path = require 'path'
accord = require '../'
File = require 'fobject'

describe 'marc', ->
  before ->
    @marc = accord.load('marc')
    @path = path.join(__dirname, 'fixtures', 'marc')

  it 'should expose name, extensions, output, and engine', ->
    @marc.extensions.should.be.an.instanceOf(Array)
    @marc.output.should.be.type('string')
    @marc.engine.should.be.ok
    @marc.name.should.be.ok

  it 'should render a string', (done) ->
    @marc.render(
      'I am using __markdown__ with {{label}}!'
      data:
        label: 'marc'
    ).catch(
      should.not.exist
    ).done((res) =>
      should.match_expected(@marc, res, path.join(@path, 'basic.md'), done)
    )

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.md')
    @marc.renderFile(lpath, data: {label: 'marc'})
      .done((res) => should.match_expected(@marc, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @marc.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))
