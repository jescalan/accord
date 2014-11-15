should = require 'should'
path = require 'path'
accord = require '../'

describe 'swig', ->
  before ->
    @swig = accord.load('swig')
    @path = path.join(__dirname, 'fixtures', 'swig')

  it 'should expose name, extensions, output, and engine', ->
    @swig.extensions.should.be.an.instanceOf(Array)
    @swig.output.should.be.type('string')
    @swig.engine.should.be.ok
    @swig.name.should.be.ok

  it 'should render a string', (done) ->
    text = '<h1>{% if foo %}Bar{% endif %}</h1>'
    @swig.render(text, locals: {foo: true}).done((res) =>
      should.match_expected(@swig, res, path.join(@path, 'string.swig'), done)
    )

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.swig')
    @swig.renderFile(lpath, locals: {author: "Jeff Escalante"}).done((res) =>
      should.match_expected(@swig, res, lpath, done)
    )

  it 'should compile a string', (done) ->
    @swig.compile("<h1>{{ title }}</h1>").done((res) =>
      should.match_expected(
        @swig
        res(title: 'Hello!').trim() + '\n'
        path.join(@path, 'pstring.swig')
        done
      )
    )

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.swig')
    @swig.compileFile(lpath).done((res) =>
      should.match_expected(
        @swig
        res(title: 'Hello!').trim() + '\n'
        lpath
        done
      )
    )

  it 'should client-compile a string', (done) ->
    text = "<h1>{% if foo %}Bar{% endif %}</h1>"
    @swig.compileClient(text, foo: true).done((res) =>
      should.match_expected(
        @swig
        res
        path.join(@path, 'cstring.swig'), done
      )
    )

  it 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.swig')
    @swig.compileFileClient(lpath).done((res) =>
      should.match_expected(@swig, res, lpath, done))

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.swig')
    @swig.renderFile(lpath)
      .done((res) => should.match_expected(@swig, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.swig')
    @swig.compileFileClient(lpath).done (resTemplate) =>
      @swig.clientHelpers().done (resHelpers) ->
        text =  "window = {}; #{resHelpers};\n var tpl = (#{(String resTemplate).trim()});\n"
        partOfClientHelpers1 = 'https://paularmstrong.github.com/swig'
        partOfClientHelpers2 = 'var tpl ='
        partOfClientHelpers3 = 'anonymous(_swig,_ctx,_filters,_utils,_fn) {'
        partOfClientHelpers4 = 'var _ext = _swig.extensions,'

        text.should.containEql partOfClientHelpers1
        text.should.containEql partOfClientHelpers2
        text.should.containEql partOfClientHelpers3
        text.should.containEql partOfClientHelpers4
        done()
