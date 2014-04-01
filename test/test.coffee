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

  it 'all should return all adapters', ->
    accord.all().should.be.type('object')

describe 'jade', ->

  before ->
    @jade = accord.load('jade')
    @path = path.join(__dirname, 'fixtures', 'jade')

  it 'should expose name, extensions, output, and compiler', ->
    @jade.extensions.should.be.an.instanceOf(Array)
    @jade.output.should.be.type('string')
    @jade.compiler.should.be.ok
    @jade.name.should.be.ok

  it 'should render a string', (done) ->
    @jade.render('p BLAHHHHH\np= foo', { foo: 'such options' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, path.join(@path, 'rstring.jade'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.jade')
    @jade.renderFile(lpath, { foo: 'such options' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, lpath, done))

  it 'should compile a string', (done) ->
    @jade.compile("p why cant I shot web?\np= foo")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res({foo: 'such options'}), path.join(@path, 'pstring.jade'), done))

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.jade')
    @jade.compileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res({foo: 'such options'}), lpath, done))

  it 'should client-compile a string', (done) ->
    @jade.compileClient("p imma firin mah lazer!\np= foo", {foo: 'such options'})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, path.join(@path, 'cstring.jade'), done))

  it 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.jade')
    @jade.compileFileClient(lpath, {foo: 'such options'})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, lpath, done))

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.jade')
    @jade.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@jade, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.jade')
    @jade.compileFileClient(lpath)
      .catch(should.not.exist)
      .done (res) =>
        tpl_string =  "#{@jade.clientHelpers()}#{res}; template({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@jade, tpl, lpath, done)

  it 'should correctly handle errors', (done) ->
    @jade.render("!= nonexistantfunction()")
      .done(should.not.exist, (-> done()))

describe 'swig', ->

  before ->
    @swig = accord.load('swig')
    @path = path.join(__dirname, 'fixtures', 'swig')

  it 'should expose name, extensions, output, and compiler', ->
    @swig.extensions.should.be.an.instanceOf(Array)
    @swig.output.should.be.type('string')
    @swig.compiler.should.be.ok
    @swig.name.should.be.ok

  it 'should render a string', (done) ->
    @swig.render('<h1>{% if foo %}Bar{% endif %}</h1>', { locals: { foo: true } })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@swig, res, path.join(@path, 'string.swig'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.swig')
    @swig.renderFile(lpath, { locals: { author: "Jeff Escalante" } })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@swig, res, lpath, done))

  it 'should compile a string', (done) ->
    @swig.compile("<h1>{{ title }}</h1>")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@swig, res({title: 'Hello!'}), path.join(@path, 'pstring.swig'), done))

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.swig')
    @swig.compileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@swig, res({title: 'Hello!'}), lpath, done))

  it 'should client-compile a string', (done) ->
    @swig.compileClient("<h1>{% if foo %}Bar{% endif %}</h1>", {foo: true})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@swig, res, path.join(@path, 'cstring.swig'), done))

  it 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.swig')
    @swig.compileFileClient(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@swig, res, lpath, done))

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.swig')
    @swig.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@swig, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.swig')
    @swig.compileFileClient(lpath)
      .catch(should.not.exist)
      .done (res) =>
        tpl_string =  "window = {}; #{@swig.clientHelpers()};\n var tpl = (#{res});"
        should.match_expected(@swig, tpl_string, lpath, done)

describe 'coffeescript', ->

  before ->
    @coffee = accord.load('coffee-script')
    @path = path.join(__dirname, 'fixtures', 'coffee')

  it 'should expose name, extensions, output, and compiler', ->
    @coffee.extensions.should.be.an.instanceOf(Array)
    @coffee.output.should.be.type('string')
    @coffee.compiler.should.be.ok
    @coffee.name.should.be.ok

  it 'should render a string', (done) ->
    @coffee.render('console.log "test"', { bare: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@coffee, res, path.join(@path, 'string.coffee'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.coffee')
    @coffee.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@coffee, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @coffee.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @coffee.render("!   ---@#$$@%#$")
      .done(should.not.exist, (-> done()))

describe 'stylus', ->

  before ->
    @stylus = accord.load('stylus')
    @path = path.join(__dirname, 'fixtures', 'stylus')

  it 'should expose name, extensions, output, and compiler', ->
    @stylus.extensions.should.be.an.instanceOf(Array)
    @stylus.output.should.be.type('string')
    @stylus.compiler.should.be.ok
    @stylus.name.should.be.ok

  it 'should render a string', (done) ->
    @stylus.render('.test\n  foo: bar')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'string.styl'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.styl')
    @stylus.renderFile(lpath)
      .catch(should.not.exist)
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
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set defines', (done) ->
    opts =
      define: { foo: 'bar', baz: 'quux' }

    @stylus.render('.test\n  test: foo', opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'defines.styl'), done))

  it 'should set includes', (done) ->
    opts =
      include: 'pluginz'

    lpath = path.join(@path, 'include1.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set multiple includes', (done) ->
    opts =
      include: ['pluginz', 'extra_plugin']

    lpath = path.join(@path, 'include2.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set imports', (done) ->
    opts =
      import: 'pluginz/lib'

    lpath = path.join(@path, 'import1.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set multiple imports', (done) ->
    opts =
      import: ['pluginz/lib', 'pluginz/lib2']

    lpath = path.join(@path, 'import2.styl')
    @stylus.renderFile(lpath, opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, lpath, done))

  it 'should set plugins', (done) ->
    opts =
      use: (style) ->
        style.define('main-width', 500)

    @stylus.render('.test\n  foo: main-width', opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'plugins1.styl'), done))

  it 'should set multiple plugins', (done) ->
    opts =
      use: [
        ((style) -> style.define('main-width', 500)),
        ((style) -> style.define('main-height', 200)),
      ]

    @stylus.render('.test\n  foo: main-width\n  bar: main-height', opts)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@stylus, res, path.join(@path, 'plugins2.styl'), done))

  it 'should correctly handle errors', (done) ->
    @stylus.render("214m2/3l")
      .done(should.not.exist, (-> done()))

describe 'ejs', ->

  before ->
    @ejs = accord.load('ejs')
    @path = path.join(__dirname, 'fixtures', 'ejs')

  it 'should expose name, extensions, output, and compiler', ->
    @ejs.extensions.should.be.an.instanceOf(Array)
    @ejs.output.should.be.type('string')
    @ejs.compiler.should.be.ok
    @ejs.name.should.be.ok

  it 'should render a string', (done) ->
    @ejs.render('<p>ejs yah</p><p><%= foo%></p>', { foo: 'wow opts' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, path.join(@path, 'rstring.ejs'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.ejs')
    @ejs.renderFile(lpath, { foo: 'wow opts' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, lpath, done))

  it 'should compile a string', (done) ->
    @ejs.compile("<p>precompilez</p><p><%= foo %></p>")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res({foo: 'wow opts'}), path.join(@path, 'pstring.ejs'), done))

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.ejs')
    @ejs.compileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res({foo: 'wow opts'}), lpath, done))

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.ejs')
    @ejs.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, lpath, done))

  it 'should client-compile a string', (done) ->
    @ejs.compileClient("Woah look, a <%= thing %>")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, path.join(@path, 'cstring.ejs'), done))

  # ejs writes the filename to the function, which makes this
  # not work cross-system as expected
  it.skip 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.ejs')
    @ejs.compileFileClient(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@ejs, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.ejs')
    @ejs.compileFileClient(lpath)
      .catch(should.not.exist)
      .done (res) =>
        tpl_string =  "#{@ejs.clientHelpers()}; var tpl = #{res}; tpl({ foo: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@ejs, tpl, lpath, done)

  it 'should correctly handle errors', (done) ->
    @ejs.render("<%= wow() %>")
      .done(should.not.exist, (-> done()))

describe 'markdown', ->

  before ->
    @markdown = accord.load('markdown')
    @path = path.join(__dirname, 'fixtures', 'markdown')

  it 'should expose name, extensions, output, and compiler', ->
    @markdown.extensions.should.be.an.instanceOf(Array)
    @markdown.output.should.be.type('string')
    @markdown.compiler.should.be.ok
    @markdown.name.should.be.ok

  it 'should render a string', (done) ->
    @markdown.render('hello **world**')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@markdown, res, path.join(@path, 'string.md'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.md')
    @markdown.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@markdown, res, lpath, done))

  it 'should render with options', (done) ->
    lpath = path.join(@path, 'opts.md')
    @markdown.renderFile(lpath, {sanitize: true})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@markdown, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @markdown.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

describe 'minify-js', ->

  before ->
    @minifyjs = accord.load('minify-js')
    @path = path.join(__dirname, 'fixtures', 'minify-js')

  it 'should expose name, extensions, output, and compiler', ->
    @minifyjs.extensions.should.be.an.instanceOf(Array)
    @minifyjs.output.should.be.type('string')
    @minifyjs.compiler.should.be.ok
    @minifyjs.name.should.be.ok

  it 'should minify a string', (done) ->
    @minifyjs.render('var foo = "foobar";\nconsole.log(foo)')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyjs, res, path.join(@path, 'string.js'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.js')
    @minifyjs.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyjs, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.js')
    @minifyjs.renderFile(lpath, { compress: false })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyjs, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @minifyjs.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @minifyjs.render("@#$%#I$$N%NI#$%I$PQ")
      .done(should.not.exist, (-> done()))

describe 'minify-css', ->

  before ->
    @minifycss = accord.load('minify-css')
    @path = path.join(__dirname, 'fixtures', 'minify-css')

  it 'should expose name, extensions, output, and compiler', ->
    @minifycss.extensions.should.be.an.instanceOf(Array)
    @minifycss.output.should.be.type('string')
    @minifycss.compiler.should.be.ok
    @minifycss.name.should.be.ok

  it 'should minify a string', (done) ->
    @minifycss.render('.test {\n  foo: bar;\n}')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifycss, res, path.join(@path, 'string.css'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.css')
    @minifycss.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifycss, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.css')
    @minifycss.renderFile(lpath, { keepBreaks: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifycss, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @minifycss.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @minifycss.render("FMWT$SP#TPO%M@#@#M!@@@")
      .done(should.not.exist, (-> done()))

describe 'minify-html', ->

  before ->
    @minifyhtml = accord.load('minify-html')
    @path = path.join(__dirname, 'fixtures', 'minify-html')

  it 'should expose name, extensions, output, and compiler', ->
    @minifyhtml.extensions.should.be.an.instanceOf(Array)
    @minifyhtml.output.should.be.type('string')
    @minifyhtml.compiler.should.be.ok
    @minifyhtml.name.should.be.ok

  it 'should minify a string', (done) ->
    @minifyhtml.render('<div class="hi" id="">\n  <p>hello</p>\n</div>')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyhtml, res, path.join(@path, 'string.html'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.html')
    @minifyhtml.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyhtml, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.html')
    @minifyhtml.renderFile(lpath, { collapseWhitespace: false })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@minifyhtml, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @minifyhtml.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @minifyhtml.render("<<<{@$@#$")
      .done(should.not.exist, (-> done()))

describe 'csso', ->

  before ->
    @csso = accord.load('csso')
    @path = path.join(__dirname, 'fixtures', 'csso')

  it 'should expose name, extensions, output, and compiler', ->
    @csso.extensions.should.be.an.instanceOf(Array)
    @csso.output.should.be.type('string')
    @csso.compiler.should.be.ok
    @csso.name.should.be.ok

  it 'should minify a string', (done) ->
    @csso.render(".hello { foo: bar; }\n .hello { color: green }")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@csso, res, path.join(@path, 'string.css'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.css')
    @csso.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@csso, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.css')
    @csso.renderFile(lpath, { noRestructure: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@csso, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @csso.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @csso.render("wow")
      .done(should.not.exist, (-> done()))

describe 'mustache', ->

  before ->
    @mustache = accord.load('mustache')
    @path = path.join(__dirname, 'fixtures', 'mustache')

  it 'should expose name, extensions, output, and compiler', ->
    @mustache.extensions.should.be.an.instanceOf(Array)
    @mustache.output.should.be.type('string')
    @mustache.compiler.should.be.ok
    @mustache.name.should.be.ok

  it 'should render a string', (done) ->
    @mustache.render("Why hello, {{ name }}!", { name: 'dogeudle' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@mustache, res, path.join(@path, 'string.mustache'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.mustache')
    @mustache.renderFile(lpath, { name: 'doge', winner: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@mustache, res, lpath, done))

  it 'should compile a string', (done) ->
    @mustache.compile("Wow, such {{ noun }}")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@mustache, res.render({noun: 'compile'}), path.join(@path, 'pstring.mustache'), done))

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.mustache')
    @mustache.compileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@mustache, res.render({name: 'foo'}), lpath, done))

  it 'client compile should work', (done) ->
    lpath = path.join(@path, 'client-complex.mustache')
    @mustache.compileFileClient(lpath)
      .catch(should.not.exist)
      .done (res) =>
        tpl_string =  "#{@mustache.clientHelpers()}; var tpl = #{res} tpl.render({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@mustache, tpl, lpath, done)

  it 'should handle partials', (done) ->
    lpath = path.join(@path, 'partial.mustache')
    @mustache.renderFile(lpath, { foo: 'bar', partials: { partial: 'foo {{ foo }}' } })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@mustache, res, lpath, done))

  it 'should correctly handle errors', (done) ->
    @mustache.render("{{# !@{!# }}")
      .done(should.not.exist, (-> done()))

describe 'dogescript', ->

  before ->
    @doge = accord.load('dogescript')
    @path = path.join(__dirname, 'fixtures', 'dogescript')

  it 'should expose name, extensions, output, and compiler', ->
    @doge.extensions.should.be.an.instanceOf(Array)
    @doge.output.should.be.type('string')
    @doge.compiler.should.be.ok
    @doge.name.should.be.ok

  it 'should render a string', (done) ->
    @doge.render("console dose loge with 'wow'", { beautify: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@doge, res, path.join(@path, 'string.djs'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.djs')
    @doge.renderFile(lpath, { trueDoge: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@doge, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @doge.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  # it turns out that it's impossible for dogescript to throw an error
  # which, honestly, is how it should be. so no test here.

describe 'handlebars', ->

  before ->
    @handlebars = accord.load('handlebars')
    @path = path.join(__dirname, 'fixtures', 'handlebars')

  it 'should expose name, extensions, output, and compiler', ->
    @handlebars.extensions.should.be.an.instanceOf(Array)
    @handlebars.output.should.be.type('string')
    @handlebars.compiler.should.be.ok
    @handlebars.name.should.be.ok

  it 'should render a string', (done) ->
    @handlebars.render('Hello there {{ name }}', { name: 'homie' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@handlebars, res, path.join(@path, 'rstring.hbs'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.hbs')
    @handlebars.renderFile(lpath, { compiler: 'handlebars' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@handlebars, res, lpath, done))

  it 'should compile a string', (done) ->
    @handlebars.compile('Hello there {{ name }}')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@handlebars, res({ name: 'my friend' }), path.join(@path, 'pstring.hbs'), done))

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.hbs')
    @handlebars.compileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@handlebars, res({ friend: 'r kelly' }), lpath, done))

  it 'should client-compile a string', (done) ->
    @handlebars.compileClient("Here comes the {{ thing }}")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@handlebars, res, path.join(@path, 'cstring.hbs'), done))

  it 'should client-compile a file', (done) ->
    lpath = path.join(@path, 'client.hbs')
    @handlebars.compileFileClient(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@handlebars, res, lpath, done))

  it 'should handle external file requests', (done) ->
    lpath = path.join(@path, 'partial.hbs')
    @handlebars.renderFile(lpath, { partials: { foo: "<p>hello from a partial!</p>" }})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@handlebars, res, lpath, done))

  it 'should render with client side helpers', (done) ->
    lpath = path.join(@path, 'client-complex.hbs')
    @handlebars.compileFileClient(lpath)
      .catch(should.not.exist)
      .done (res) =>
        tpl_string =  "#{@handlebars.clientHelpers()}; var tpl = #{res}; tpl({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@handlebars, tpl, lpath, done)

  it 'should correctly handle errors', (done) ->
    @handlebars.render("{{# !@{!# }}")
      .done(should.not.exist, (-> done()))

describe 'scss', ->

  before ->
    @scss = accord.load('scss')
    @path = path.join(__dirname, 'fixtures', 'scss')

  it 'should expose name, extensions, output, and compiler', ->
    @scss.extensions.should.be.an.instanceOf(Array)
    @scss.output.should.be.type('string')
    @scss.compiler.should.be.ok
    @scss.name.should.be.ok

  it 'should render a string', (done) ->
    @scss.render("$wow: 'red'; foo { bar: $wow; }")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@scss, res, path.join(@path, 'string.scss'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.scss')
    @scss.renderFile(lpath, { trueDoge: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@scss, res, lpath, done))

  it 'should include external files', (done) ->
    lpath = path.join(@path, 'external.scss')
    @scss.renderFile(lpath, { includePaths: [@path] })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@scss, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @scss.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @scss.render("!@##%#$#^$")
      .done(should.not.exist, (-> done()))

describe 'less', ->

  before ->
    @less = accord.load('less')
    @path = path.join(__dirname, 'fixtures', 'less')

  it 'should expose name, extensions, output, and compiler', ->
    @less.extensions.should.be.an.instanceOf(Array)
    @less.output.should.be.type('string')
    @less.compiler.should.be.ok
    @less.name.should.be.ok

  it 'should render a string', (done) ->
    @less.render(".foo { width: 100 + 20 }")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@less, res, path.join(@path, 'string.less'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.less')
    @less.renderFile(lpath, { trueDoge: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@less, res, lpath, done))

  it 'should include external files', (done) ->
    lpath = path.join(@path, 'external.less')
    @less.renderFile(lpath, { paths: [@path] })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@less, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @less.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @less.render("!@##%#$#^$")
      .done(should.not.exist, (-> done()))

describe 'coco', ->

  before ->
    @coco = accord.load('coco')
    @path = path.join(__dirname, 'fixtures', 'coco')

  it 'should expose name, extensions, output, and compiler', ->
    @coco.extensions.should.be.an.instanceOf(Array)
    @coco.output.should.be.type('string')
    @coco.compiler.should.be.ok
    @coco.name.should.be.ok

  it 'should render a string', (done) ->
    @coco.render("function test\n  console.log('foo')", { bare: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@coco, res, path.join(@path, 'string.co'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.co')
    @coco.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@coco, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @coco.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @coco.render("!! ---  )I%$_(I(YRTO")
      .done(should.not.exist, (-> done()))

describe 'livescript', ->

  before ->
    @livescript = accord.load('LiveScript')
    @path = path.join(__dirname, 'fixtures', 'livescript')

  it 'should expose name, extensions, output, and compiler', ->
    @livescript.extensions.should.be.an.instanceOf(Array)
    @livescript.output.should.be.type('string')
    @livescript.compiler.should.be.ok
    @livescript.name.should.be.ok

  it 'should render a string', (done) ->
    @livescript.render("test = ~> console.log('foo')", { bare: true })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@livescript, res, path.join(@path, 'string.ls'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.ls')
    @livescript.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@livescript, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @livescript.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @livescript.render("!! ---  )I%$_(I(YRTO")
      .done(should.not.exist, (-> done()))

describe 'myth', ->

  before ->
    @myth = accord.load('myth')
    @path = path.join(__dirname, 'fixtures', 'myth')

  it 'should expose name, extensions, output, and compiler', ->
    @myth.extensions.should.be.an.instanceOf(Array)
    @myth.output.should.be.type('string')
    @myth.compiler.should.be.ok
    @myth.name.should.be.ok

  it 'should render a string', (done) ->
    @myth.render(".foo { transition: all 1s ease; }")
      .catch(should.not.exist)
      .done((res) => should.match_expected(@myth, res, path.join(@path, 'string.myth'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.myth')
    @myth.renderFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@myth, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @myth.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @myth.render("!! ---  )I%$_(I(YRTO")
      .done(should.not.exist, (-> done()))

describe 'haml', ->

  before ->
    @haml = accord.load('haml')
    @path = path.join(__dirname, 'fixtures', 'haml')

  it 'should expose name, extensions, output, and compiler', ->
    @haml.extensions.should.be.an.instanceOf(Array)
    @haml.output.should.be.type('string')
    @haml.compiler.should.be.ok
    @haml.name.should.be.ok

  it 'should render a string', (done) ->
    @haml.render('%div.foo= "Whats up " + name', { name: 'mang' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@haml, res, path.join(@path, 'rstring.haml'), done))

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.haml')
    @haml.renderFile(lpath, { compiler: 'haml' })
      .catch(should.not.exist)
      .done((res) => should.match_expected(@haml, res, lpath, done))

  it 'should compile a string', (done) ->
    @haml.compile('%p= "Hello there " + name')
      .catch(should.not.exist)
      .done((res) => should.match_expected(@haml, res({ name: 'my friend' }), path.join(@path, 'pstring.haml'), done))

  it 'should compile a file', (done) ->
    lpath = path.join(@path, 'precompile.haml')
    @haml.compileFile(lpath)
      .catch(should.not.exist)
      .done((res) => should.match_expected(@haml, res({ friend: 'doge' }), lpath, done))

  it 'should not support client compiles', (done) ->
    @haml.compileClient("%p= 'Here comes the ' + thing")
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @haml.render("%p= wow()")
      .done(should.not.exist, (-> done()))

describe 'marc', ->

  before ->
    @marc = accord.load('marc')
    @path = path.join(__dirname, 'fixtures', 'marc')

  it 'should expose name, extensions, output, and compiler', ->
    @marc.extensions.should.be.an.instanceOf(Array)
    @marc.output.should.be.type('string')
    @marc.compiler.should.be.ok
    @marc.name.should.be.ok

  it 'should render a string', (done) ->
    @marc.render(
      'I am using __markdown__ with {{label}}!'
      data:
        label: 'marc'
    ).catch(
      should.not.exist
    ).done((res) =>
      should.match_expected(@marc, res, path.join(@path, 'basic.md'), done)
    )

  it 'should render a file', (done) ->
    lpath = path.join(@path, 'basic.md')
    @marc.renderFile(lpath, data: {label: 'marc'})
      .catch(should.not.exist)
      .done((res) => should.match_expected(@marc, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @marc.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))
