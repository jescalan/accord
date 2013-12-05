should = require 'should'
path = require 'path'
accord = require '../'

describe 'base functions', ->

  it 'supports should work', ->
    accord.supports('jade').should.be.ok
    accord.supports('blargh').should.not.be.ok

  it 'load should work', ->
    (-> accord.load('jade')).should.not.throw
    (-> accord.load('blargh')).should.throw

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

  it 'should handle external file requests', ->
    @jade.renderFile(path.join(@path, 'partial.jade'))
      .done (res) ->
        console.log res
      , should.not.exist

describe 'coffeescript', ->

  before ->
    @coffee = accord.load('coffee-script')
    @path = path.join(__dirname, 'fixtures', 'coffee')

  it 'should render a string', ->
    @coffee.render('console.log "test"', { bare: true })
      .done (res) ->
        console.log res
      , should.not.exist

  it 'should render a file', ->
    @coffee.renderFile(path.join(@path, 'basic.coffee'))
      .done (res) ->
        console.log res
      , should.not.exist

  it 'should not be able to precompile', ->
    @coffee.precompile()
      .done(should.not.exist, should.exist)
