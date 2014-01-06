should = require 'should'
path = require 'path'
accord = require '../'

require('./helpers')(should)

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

  it 'should expose name, extensions, output, and compiler', ->
    @jade.extensions.should.be.an.instanceOf(Array)
    @jade.output.should.be.type('string')
    @jade.compiler.should.be.ok
    @jade.name.should.be.ok

  it 'should render a string', ->
    @jade.render('p BLAHHHHH\np= foo', { foo: 'such options' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, path.join(@path, 'rstring.jade')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.jade')
    @jade.renderFile(lpath, { foo: 'such options' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, lpath))

  it 'should compile a string', ->
    @jade.compile("p why cant I shot web?\np= foo")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res({foo: 'such options'}), path.join(@path, 'pstring.jade')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.jade')
    @jade.compileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res({foo: 'such options'}), lpath))

  it 'should handle external file requests', ->
    lpath = path.join(@path, 'partial.jade')
    @jade.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, lpath))

describe 'coffeescript', ->

  before ->
    @coffee = accord.load('coffee-script')
    @path = path.join(__dirname, 'fixtures', 'coffee')

  it 'should expose name, extensions, output, and compiler', ->
    @coffee.extensions.should.be.an.instanceOf(Array)
    @coffee.output.should.be.type('string')
    @coffee.compiler.should.be.ok
    @coffee.name.should.be.ok

  it 'should render a string', ->
    @coffee.render('console.log "test"', { bare: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@coffee, res, path.join(@path, 'string.coffee')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.coffee')
    @coffee.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@coffee, res, lpath))

  it 'should not be able to precompile', ->
    @coffee.precompile()
      .done(should.not.exist, should.exist)

describe 'stylus', ->

  before ->
    @stylus = accord.load('stylus')
    @path = path.join(__dirname, 'fixtures', 'stylus')

  it 'should expose name, extensions, output, and compiler', ->
    @stylus.extensions.should.be.an.instanceOf(Array)
    @stylus.output.should.be.type('string')
    @stylus.compiler.should.be.ok
    @stylus.name.should.be.ok

  it 'should render a string', ->
    @stylus.render('.test\n  foo: bar')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'string.styl')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.styl')
    @stylus.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath))

  it 'should not be able to precompile', ->
    @stylus.precompile()
      .done(should.not.exist, should.exist)

  it 'should set normal options', ->
    opts =
      paths: ['pluginz']
      foo: 'bar'

    lpath = path.join(@path, 'include1.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath))

  it 'should set defines', ->
    opts =
      define: { foo: 'bar', baz: 'quux' }

    @stylus.render('.test\n  test: foo', opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'defines.styl')))

  it 'should set includes', ->
    opts =
      include: 'pluginz'

    lpath = path.join(@path, 'include1.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath))

  it 'should set multiple includes', ->
    opts =
      include: ['pluginz', 'extra_plugin']

    lpath = path.join(@path, 'include2.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath))

  it 'should set imports', ->
    opts =
      import: 'pluginz/lib'

    lpath = path.join(@path, 'import1.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath))

  it 'should set multiple imports', ->
    opts =
      import: ['pluginz/lib', 'pluginz/lib2']

    lpath = path.join(@path, 'import2.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath))

  it 'should set plugins', ->
    opts =
      use: (style) ->
        style.define('main-width', 500)

    @stylus.render('.test\n  foo: main-width', opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'plugins1.styl')))

  it 'should set multiple plugins', ->
    opts =
      use: [
        ((style) -> style.define('main-width', 500)),
        ((style) -> style.define('main-height', 200)),
      ]

    @stylus.render('.test\n  foo: main-width\n  bar: main-height', opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'plugins2.styl')))

describe 'ejs', ->

  before ->
    @ejs = accord.load('ejs')
    @path = path.join(__dirname, 'fixtures', 'ejs')

  it 'should expose name, extensions, output, and compiler', ->
    @ejs.extensions.should.be.an.instanceOf(Array)
    @ejs.output.should.be.type('string')
    @ejs.compiler.should.be.ok
    @ejs.name.should.be.ok

  it 'should render a string', ->
    @ejs.render('<p>ejs yah</p><p><%= foo%></p>', { foo: 'wow opts' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, path.join(@path, 'rstring.ejs')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.ejs')
    @ejs.renderFile(lpath, { foo: 'wow opts' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, lpath))

  it 'should precompile a string', ->
    @ejs.precompile("<p>precompilez</p><p><%= foo %></p>")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res({foo: 'wow opts'}), path.join(@path, 'pstring.ejs')))

  it 'should precompile a file', ->
    lpath = path.join(@path, 'precompile.ejs')
    @ejs.precompileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res({foo: 'wow opts'}), lpath))

  it 'should handle external file requests', ->
    lpath = path.join(@path, 'partial.ejs')
    @ejs.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, lpath))

describe 'markdown', ->

  before ->
    @markdown = accord.load('markdown')
    @path = path.join(__dirname, 'fixtures', 'markdown')

  it 'should expose name, extensions, output, and compiler', ->
    @markdown.extensions.should.be.an.instanceOf(Array)
    @markdown.output.should.be.type('string')
    @markdown.compiler.should.be.ok
    @markdown.name.should.be.ok

  it 'should render a string', ->
    @markdown.render('hello **world**')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@markdown, res, path.join(@path, 'string.md')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.md')
    @markdown.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@markdown, res, lpath))

  it 'should render with options', ->
    lpath = path.join(@path, 'opts.md')
    @markdown.renderFile(lpath, {sanitize: true})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@markdown, res, lpath))

  it 'should not be able to precompile', ->
    @markdown.precompile()
      .done(should.not.exist, should.exist)

describe 'minify-js', ->

  before ->
    @minifyjs = accord.load('minify-js')
    @path = path.join(__dirname, 'fixtures', 'minify-js')

  it 'should expose name, extensions, output, and compiler', ->
    @minifyjs.extensions.should.be.an.instanceOf(Array)
    @minifyjs.output.should.be.type('string')
    @minifyjs.compiler.should.be.ok
    @minifyjs.name.should.be.ok

  it 'should minify a string', ->
    @minifyjs.render('var foo = "foobar";\nconsole.log(foo)')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyjs, res, path.join(@path, 'string.js')))

  it 'should minify a file', ->
    lpath = path.join(@path, 'basic.js')
    @minifyjs.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyjs, res, lpath))

  it 'should minify with options', ->
    lpath = path.join(@path, 'opts.js')
    @minifyjs.renderFile(lpath, { compress: false })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyjs, res, lpath))

  it 'should not be able to precompile', ->
    @minifyjs.precompile()
      .done(should.not.exist, should.exist)

describe 'minify-css', ->

  before ->
    @minifycss = accord.load('minify-css')
    @path = path.join(__dirname, 'fixtures', 'minify-css')

  it 'should expose name, extensions, output, and compiler', ->
    @minifycss.extensions.should.be.an.instanceOf(Array)
    @minifycss.output.should.be.type('string')
    @minifycss.compiler.should.be.ok
    @minifycss.name.should.be.ok

  it 'should minify a string', ->
    @minifycss.render('.test {\n  foo: bar;\n}')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifycss, res, path.join(@path, 'string.css')))

  it 'should minify a file', ->
    lpath = path.join(@path, 'basic.css')
    @minifycss.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifycss, res, lpath))

  it 'should minify with options', ->
    lpath = path.join(@path, 'opts.css')
    @minifycss.renderFile(lpath, { keepBreaks: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifycss, res, lpath))

  it 'should not be able to precompile', ->
    @minifycss.precompile()
      .done(should.not.exist, should.exist)

describe 'minify-html', ->

  before ->
    @minifyhtml = accord.load('minify-html')
    @path = path.join(__dirname, 'fixtures', 'minify-html')

  it 'should expose name, extensions, output, and compiler', ->
    @minifyhtml.extensions.should.be.an.instanceOf(Array)
    @minifyhtml.output.should.be.type('string')
    @minifyhtml.compiler.should.be.ok
    @minifyhtml.name.should.be.ok

  it 'should minify a string', ->
    @minifyhtml.render('<div class="hi" id="">\n  <p>hello</p>\n</div>')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyhtml, res, path.join(@path, 'string.html')))

  it 'should minify a file', ->
    lpath = path.join(@path, 'basic.html')
    @minifyhtml.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyhtml, res, lpath))

  it 'should minify with options', ->
    lpath = path.join(@path, 'opts.html')
    @minifyhtml.renderFile(lpath, { collapseWhitespace: false })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyhtml, res, lpath))

  it 'should not be able to precompile', ->
    @minifyhtml.precompile()
      .done(should.not.exist, should.exist)
