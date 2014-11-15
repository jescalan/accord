should = require 'should'
path = require 'path'
W = require 'when'
accord = require '../'

describe 'handlebars', ->
  before ->
    @handlebars = accord.load('handlebars')
    @path = path.join(__dirname, 'fixtures', 'handlebars')

  it 'should expose name, extensions, output, and engine', ->
    @handlebars.extensions.should.be.an.instanceOf(Array)
    @handlebars.output.should.be.type('string')
    @handlebars.engine.should.be.ok
    @handlebars.name.should.be.ok

  it 'should render a string', (done) ->
    @handlebars.render('Hello there {{ name }}', name: 'homie')
      .done((res) => should.match_expected(@handlebars, res, path.join(@path, 'rstring.hbs'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.hbs')
    @handlebars.renderFile(lpath, compiler: 'handlebars')
      .done((res) => should.match_expected(@handlebars, res, lpath, done))

  it 'should compile a string', (done) ->
    @handlebars.compile('Hello there {{ name }}').done((res) =>
      should.match_expected(
        @handlebars
        res(name: 'my friend').trim() + '\n'
        path.join(@path, 'pstring.hbs')
        done
      )
    )

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.hbs')
    @handlebars.compileFile(lpath).done((res) =>
      should.match_expected(
        @handlebars
        res(friend: 'r kelly').trim() + '\n'
        lpath
        done
      )
    )

  it 'should client-compile a string', (done) ->
    @handlebars.compileClient("Here comes the {{ thing }}").done((res) =>
      should.match_expected(@handlebars, res, path.join(@path, 'cstring.hbs'), done))

  it 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.hbs')
    @handlebars.compileFileClient(lpath).done((res) =>
      should.match_expected(@handlebars, res, lpath, done))

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.hbs')
    @handlebars.renderFile(lpath, { partials: { foo: "<p>hello from a partial!</p>" }})
      .done((res) => should.match_expected(@handlebars, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.hbs')
    @handlebars.compileFileClient(lpath).done (res) =>
      @handlebars.clientHelpers().done (clientHelpers) =>
        tpl_string = "#{clientHelpers}; var tpl = #{res}; tpl({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@handlebars, tpl.trim() + '\n', lpath, done)

  it 'should correctly handle errors', (done) ->
    @handlebars.render("{{# !@{!# }}")
      .done(should.not.exist, (-> done()))
