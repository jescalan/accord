should = require 'should'
path = require 'path'
accord = require '../'

describe 'ejs', ->
  before ->
    @ejs = accord.load('ejs')
    @path = path.join(__dirname, 'fixtures', 'ejs')

  it 'should expose name, extensions, output, and engine', ->
    @ejs.extensions.should.be.an.instanceOf(Array)
    @ejs.output.should.be.type('string')
    @ejs.engine.should.be.ok
    @ejs.name.should.be.ok

  it 'should render a string', (done) ->
    @ejs.render('<p>ejs yah</p><p><%= foo%></p>', { foo: 'wow opts' })
      .done((res) => should.match_expected(@ejs, res, path.join(@path, 'rstring.ejs'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.ejs')
    @ejs.renderFile(lpath, { foo: 'wow opts' })
      .done((res) => should.match_expected(@ejs, res, lpath, done))

  it 'should compile a string', (done) ->
    @ejs.compile("<p>precompilez</p><p><%= foo %></p>").done((res) =>
      should.match_expected(
        @ejs
        res(foo: 'wow opts').trim() + '\n'
        path.join(@path, 'pstring.ejs')
        done
      )
    )

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.ejs')
    @ejs.compileFile(lpath).done((res) =>
      should.match_expected(
        @ejs
        res(foo: 'wow opts').trim() + '\n'
        lpath
        done
      )
    )

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.ejs')
    @ejs.renderFile(lpath)
      .done((res) => should.match_expected(@ejs, res, lpath, done))

  it 'should client-compile a string', (done) ->
    @ejs.compileClient("Woah look, a <%= thing %>").done((res) =>
      should.match_expected(@ejs, res, path.join(@path, 'cstring.ejs'), done)
    )

  # ejs writes the filename to the function, which makes this
  # not work cross-system as expected
  it.skip 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.ejs')
    @ejs.compileFileClient(lpath)
      .done((res) => should.match_expected(@ejs, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.ejs')
    @ejs.compileFileClient(lpath).done (resTemplate) =>
      @ejs.clientHelpers().done (resHelpers) =>
        tpl_string =  "#{resHelpers}; var tpl = #{resTemplate}; tpl({ foo: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@ejs, tpl, lpath, done)

  it 'should correctly handle errors', (done) ->
    @ejs.render("<%= wow() %>")
      .done(should.not.exist, (-> done()))
