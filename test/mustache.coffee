should = require 'should'
path = require 'path'
accord = require '../'

describe 'mustache', ->
  before ->
    @mustache = accord.load('mustache')
    @path = path.join(__dirname, 'fixtures', 'mustache')

  it 'should expose name, extensions, output, and engine', ->
    @mustache.extensions.should.be.an.instanceOf(Array)
    @mustache.output.should.be.type('string')
    @mustache.engine.should.be.ok
    @mustache.name.should.be.ok

  it 'should render a string', (done) ->
    @mustache.render("Why hello, {{ name }}!", { name: 'dogeudle' })
      .done((res) => should.match_expected(@mustache, res, path.join(@path, 'string.mustache'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.mustache')
    @mustache.renderFile(lpath, { name: 'doge', winner: true })
      .done((res) => should.match_expected(@mustache, res, lpath, done))

  it 'should compile a string', (done) ->
    @mustache.compile("Wow, such {{ noun }}").done((res) =>
      should.match_expected(
        @mustache
        res.render(noun: 'compile').trim() + '\n'
        path.join(@path, 'pstring.mustache')
        done
      )
    )

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.mustache')
    @mustache.compileFile(lpath).done((res) =>
      should.match_expected(
        @mustache
        res.render(name: 'foo').trim() + '\n'
        lpath
        done
      )
    )

  it 'client compile should work', (done) ->
    lpath = path.join(@path, 'client-complex.mustache')
    @mustache.compileFileClient(lpath).done (res) =>
      @mustache.clientHelpers().done (clientHelpers) =>
        tpl_string =  "#{clientHelpers}; var tpl = #{res} tpl.render({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@mustache, tpl, lpath, done)

  it 'should handle partials', (done) ->
    lpath = path.join(@path, 'partial.mustache')
    @mustache.renderFile(lpath, { foo: 'bar', partials: { partial: 'foo {{ foo }}' } })
      .done((res) => should.match_expected(@mustache, res, lpath, done))

  it 'should correctly handle errors', (done) ->
    @mustache.render("{{# !@{!# }}")
      .done(should.not.exist, (-> done()))
