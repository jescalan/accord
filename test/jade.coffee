should = require 'should'
path = require 'path'
W = require 'when'
_ = require 'lodash'
accord = require '../'

describe 'jade', ->
  before ->
    @jade = accord.load('jade')
    @path = path.join(__dirname, 'fixtures', 'jade')

  it 'should expose name, extensions, output, and engine', ->
    @jade.extensions.should.be.an.instanceOf(Array)
    @jade.output.should.be.type('string')
    @jade.engine.should.be.ok
    @jade.name.should.be.ok

  it 'should render a string', (done) ->
    @jade.render('p BLAHHHHH\np= foo', { foo: 'such options' })
      .done((res) => should.match_expected(@jade, res, path.join(@path, 'rstring.jade'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.jade')
    @jade.renderFile(lpath, { foo: 'such options' })
      .done((res) => should.match_expected(@jade, res, lpath, done))

  it 'should compile a string', (done) ->
    @jade.compile("p why cant I shot web?\np= foo").done (res) =>
      should.match_expected(
        @jade
        res(foo: 'such options').trim() + '\n'
        path.join(@path, 'pstring.jade')
        done
      )

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.jade')
    @jade.compileFile(lpath).done (res) =>
      should.match_expected(
        @jade
        res(foo: 'such options').trim() + '\n'
        lpath
        done
      )

  it 'should client-compile a string', (done) ->
    text = "p imma firin mah lazer!\np= foo"
    @jade.compileClient(text, foo: 'such options').done((res) =>
      should.match_expected(@jade, res, path.join(@path, 'cstring.jade'), done))

  it 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.jade')
    @jade.compileFileClient(lpath, foo: 'such options').done((res) =>
      should.match_expected(@jade, res, lpath, done))

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.jade')
    @jade.renderFile(lpath)
      .done((res) => should.match_expected(@jade, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.jade')
    @jade.compileFileClient(lpath).done (resTemplate) =>
      @jade.clientHelpers().done (resHelpers) =>
        text = "#{resHelpers}#{resTemplate}; template({ wow: 'local' })"
        tpl = eval.call(global, text).trim() + '\n'
        should.match_expected(@jade, tpl, lpath, done)

  it 'should correctly handle errors', (done) ->
    @jade.render("!= nonexistantfunction()")
      .done(should.not.exist, (-> done()))

  it "should handle rapid async calls with different deeply nested locals correctly", (done) ->
    lpath = path.join(@path, 'async.jade')
    opts  = {wow: {such: 'test'}}
    W.map [1..100], (i) =>
      opts.wow = {such: i}
      @jade.renderFile(lpath, opts).catch(should.not.exist)
    .then (res) ->
      _.uniq(res).length.should.equal(res.length)
      done()
    .catch(done)
