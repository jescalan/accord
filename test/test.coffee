should = require 'should'
path = require 'path'
accord = require '../'

describe 'jade', ->

  before ->
    @jade = accord.load('jade')
    @path = path.join(__dirname, 'fixtures', 'jade')

  it 'should render a string', ->
    @jade.render('p BLAHHHHH\np= foo', { foo: 'such options' })
      .done (res) ->
        console.log res
      , should.not.exist

  it 'should render a file', ->
    @jade.renderFile(path.join(@path, 'basic.jade'), { foo: 'such options' })
      .done (res) ->
        console.log res
      , should.not.exist

  it 'should precompile a string', ->
    @jade.precompile('p why cant I shot web?\n p= foo')
      .done (res) ->
        console.log res({ foo: 'such options' })
      , should.not.exist

  it 'should precompile a file', ->
    @jade.precompileFile(path.join(@path, 'precompile.jade'))
      .done (res) ->
        console.log res({ foo: 'such options' })
      , should.not.exist
