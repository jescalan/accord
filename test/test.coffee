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

  it 'should client-compile a file', (done) ->
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
