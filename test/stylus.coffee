should = require 'should'
path = require 'path'
accord = require '../'

describe 'stylus', ->
  before ->
    @stylus = accord.load('stylus')
    @path = path.join(__dirname, 'fixtures', 'stylus')

  it 'should expose name, extensions, output, and engine', ->
    @stylus.extensions.should.be.an.instanceOf(Array)
    @stylus.output.should.be.type('string')
    @stylus.engine.should.be.ok
    @stylus.name.should.be.ok

  it 'should render a string', (done) ->
    @stylus.render('.test\n  foo: bar')
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'string.styl'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.styl')
    @stylus.renderFile(lpath)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @stylus.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should set normal options', (done) ->
    opts =
      paths: ['pluginz']
      foo: 'bar'

    lpath = path.join(@path, 'include1.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should correctly import css files', (done) ->
    opts =
      "include css": true

    lpath = path.join(@path, 'include_css.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set vanilla url function', (done) ->
    opts =
      url: 'embedurl'

    lpath = path.join(@path, 'embedurl.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set url function with options', (done) ->
    opts =
      url:
        name: 'embedurl'
        limit: 10

    lpath = path.join(@path, 'embedurl.styl')
    epath = path.join(@path, 'embedurl-opts.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, epath, done))

  it 'should set defines', (done) ->
    opts =
      define: { foo: 'bar', baz: 'quux' }

    @stylus.render('.test\n  test: foo', opts)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'defines.styl'), done))

  it 'should set includes', (done) ->
    opts =
      include: 'pluginz'

    lpath = path.join(@path, 'include1.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set multiple includes', (done) ->
    opts =
      include: ['pluginz', 'extra_plugin']

    lpath = path.join(@path, 'include2.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set imports', (done) ->
    opts =
      import: 'pluginz/lib'

    lpath = path.join(@path, 'import1.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set multiple imports', (done) ->
    opts =
      import: ['pluginz/lib', 'pluginz/lib2']

    lpath = path.join(@path, 'import2.styl')
    @stylus.renderFile(lpath, opts)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set plugins', (done) ->
    opts =
      use: (style) ->
        style.define('main-width', 500)

    @stylus.render('.test\n  foo: main-width', opts)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'plugins1.styl'), done))

  it 'should set multiple plugins', (done) ->
    opts =
      use: [
        ((style) -> style.define('main-width', 500)),
        ((style) -> style.define('main-height', 200)),
      ]

    @stylus.render('.test\n  foo: main-width\n  bar: main-height', opts)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'plugins2.styl'), done))

  it 'should correctly handle errors', (done) ->
    @stylus.render("214m2/3l")
      .done(should.not.exist, (-> done()))

  it 'should produce sourcemaps', (done) ->
    @stylus.render('.test\n  test: foo').done (res) ->
      res.sourceMap.mappings.should.eql('AAAA;EACE,MAAM,IAAN')
      res.text.should.eql('.test {\n  test: foo;\n}\n')
      done()
