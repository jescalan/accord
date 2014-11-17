should = require 'should'
path = require 'path'
accord = require '../'

require('./helpers')(should)

describe 'base functions', ->
  it 'supports should work', ->
    accord.supports('jade').should.be.ok
    accord.supports('markdown').should.be.ok
    accord.supports('marked').should.be.ok
    accord.supports('blargh').should.not.be.ok

  it 'load should work', ->
    (-> accord.load('jade')).should.not.throw()
    (-> accord.load('blargh')).should.throw()

  it 'load should accept a custom path', ->
    (-> accord.load('jade', path.join(__dirname, '../node_modules/jade'))).should.not.throw()

  it "load should resolve a custom path using require's algorithm", ->
    (-> accord.load('jade', path.join(__dirname, '../node_modules/jade/missing/path'))).should.not.throw()

  it 'all should return all adapters', ->
    accord.all().should.be.type('object')
