should = require 'should'
path = require 'path'
accord = require '../'

describe 'toffee', ->
  before ->
    @toffee = accord.load('toffee')
    @path = path.join(__dirname, 'fixtures', 'toffee')

  it 'should expose name, extensions, output, and engine', ->
    @toffee.extensions.should.be.an.instanceOf(Array)
    @toffee.output.should.be.type('string')
    @toffee.engine.should.be.ok
    @toffee.name.should.be.ok

  it 'should render a string', (done) ->
    @toffee.render('''
      {#
        for supply in supplies {:<li>#{supply}</li>:}
      #}
      ''',
      supplies: ['mop', 'trash bin', 'flashlight']
    ).catch(
      should.not.exist
    ).done((res) =>
      should.match_expected(@toffee, res.text, path.join(@path, 'basic.toffee'), done)
    )

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.toffee')
    @toffee.renderFile(lpath, {supplies: ['mop', 'trash bin', 'flashlight']})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@toffee, res.text, lpath, done))

  it 'should compile a string', (done) ->
    @toffee.compile('''
      {#
        for supply in supplies {:<li>#{supply}</li>:}
      #}
      ''',
      supplies: ['mop', 'trash bin', 'flashlight']
    ).catch(
      should.not.exist
    ).done((res) =>
      should.match_expected(@toffee, res, path.join(@path, 'template.toffee'), done)
    )

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'template.toffee')
    @toffee.compileFile(lpath, supplies: ['mop', 'trash bin', 'flashlight'])
      .catch(should.not.exist)
      .done((res) => should.match_expected(@toffee, res, lpath, done))
