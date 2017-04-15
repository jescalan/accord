path = require 'path'
fs   = require 'fs'
uniq = require 'lodash.uniq'

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
    accord.all().should.be.a('object')

  it.skip 'should throw an error when attempting to load an unsupported version', ->
    (-> accord.load('xxx'))
      .should.throw('xxx version x is not currently supported')

describe 'jade', ->

  before ->
    @jade = accord.load('jade')
    @path = path.join(__dirname, 'fixtures', 'jade')

  it 'should expose name, extensions, output, and engine', ->
    @jade.extensions.should.be.an.instanceOf(Array)
    @jade.output.should.be.a('string')
    @jade.engine.should.be.ok
    @jade.name.should.be.ok

  it 'should render a string', ->
    @jade.render('p BLAHHHHH\np= foo', { foo: 'such options' })
      .then((res) => should.match_expected(@jade, res.result, path.join(@path, 'rstring.jade')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.jade')
    @jade.renderFile(lpath, { foo: 'such options' })
      .then((res) => should.match_expected(@jade, res.result, lpath))

  it 'should compile a string', ->
    @jade.compile("p why cant I shot web?\np= foo")
      .then((res) => should.match_expected(@jade, res.result({foo: 'such options'}), path.join(@path, 'pstring.jade')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.jade')
    @jade.compileFile(lpath)
      .then((res) => should.match_expected(@jade, res.result({foo: 'such options'}), lpath))

  it 'should client-compile a string', ->
    @jade.compileClient("p imma firin mah lazer!\np= foo", {foo: 'such options'})
      .then((res) => should.match_expected(@jade, res.result, path.join(@path, 'cstring.jade')))

  it 'should client-compile a file', ->
    lpath = path.join(@path, 'client.jade')
    @jade.compileFileClient(lpath, {foo: 'such options'})
      .then((res) => should.match_expected(@jade, res.result, lpath))

  it 'should handle external file requests', ->
    lpath = path.join(@path, 'partial.jade')
    @jade.renderFile(lpath)
      .then((res) => should.match_expected(@jade, res.result, lpath))

  it 'should render with client side helpers', ->
    lpath = path.join(@path, 'client-complex.jade')
    @jade.compileFileClient(lpath)
      .then (res) =>
        tpl_string =  "#{@jade.clientHelpers()}#{res.result}; template({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@jade, tpl, lpath)

  it 'should correctly handle errors', ->
    @jade.render("!= nonexistantfunction()")
      .catch((err) ->
        err.message.should.equal('nonexistantfunction is not a function on line 1')
      )

  it "should handle rapid async calls with different deeply nested locals correctly", ->
    lpath = path.join(@path, 'async.jade')
    opts  = {wow: {such: 'test'}}
    W.map [1..100], (i) =>
      opts.wow = {such: i}
      @jade.renderFile(lpath, opts).catch(should.not.exist)
    .then (res) ->
      uniq(res).length.should.equal(res.length)

describe 'pug', ->

  before ->
    @pug = accord.load('pug')
    @path = path.join(__dirname, 'fixtures', 'pug')

  it 'should expose name, extensions, output, and engine', ->
    @pug.extensions.should.be.an.instanceOf(Array)
    @pug.output.should.be.a('string')
    @pug.engine.should.be.ok
    @pug.name.should.be.ok

  it 'should render a string', ->
    @pug.render('p BLAHHHHH\np= foo', { foo: 'such options' })
      .then((res) => should.match_expected(@pug, res.result, path.join(@path, 'rstring.pug')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.pug')
    @pug.renderFile(lpath, { foo: 'such options' })
      .then((res) => should.match_expected(@pug, res.result, lpath))

  it 'should compile a string', ->
    @pug.compile("p why cant I shot web?\np= foo")
      .then((res) => should.match_expected(@pug, res.result({foo: 'such options'}), path.join(@path, 'pstring.pug')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.pug')
    @pug.compileFile(lpath)
      .then((res) => should.match_expected(@pug, res.result({foo: 'such options'}), lpath))

  it 'should client-compile a string', ->
    @pug.compileClient("p imma firin mah lazer!\np= foo")
      .then (res) =>
        tpl_string = "#{res.result}; template({ foo: 'such options' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@pug, tpl, path.join(@path, 'cstring.pug'))

  it 'should client-compile a file', ->
    lpath = path.join(@path, 'client.pug')
    @pug.compileFileClient(lpath)
      .then (res) =>
        tpl_string = "#{res.result}; template({ foo: 'such options' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@pug, tpl, lpath)

  it 'should handle external file requests', ->
    lpath = path.join(@path, 'partial.pug')
    @pug.renderFile(lpath)
      .then((res) => should.match_expected(@pug, res.result, lpath))

  it 'should render complex pug files', ->
    lpath = path.join(@path, 'client-complex.pug')
    @pug.compileFileClient(lpath)
      .then (res) =>
        tpl_string = "#{res.result}; template({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@pug, tpl, lpath)

  it 'should correctly handle errors', ->
    @pug.render("!= nonexistantfunction()")
      .catch((err) ->
        err.message.should.equal('nonexistantfunction is not a function on line 1')
      )

  it "should handle rapid async calls with different deeply nested locals correctly", ->
    lpath = path.join(@path, 'async.pug')
    opts  = {wow: {such: 'test'}}
    W.map [1..100], (i) =>
      opts.wow = {such: i}
      @pug.renderFile(lpath, opts).catch(should.not.exist)
    .then (res) ->
      uniq(res).length.should.equal(res.length)

describe 'swig', ->

  before ->
    @swig = accord.load('swig')
    @path = path.join(__dirname, 'fixtures', 'swig')

  it 'should expose name, extensions, output, and engine', ->
    @swig.extensions.should.be.an.instanceOf(Array)
    @swig.output.should.be.a('string')
    @swig.engine.should.be.ok
    @swig.name.should.be.ok

  it 'should render a string', ->
    @swig.render('<h1>{% if foo %}Bar{% endif %}</h1>', { locals: { foo: true } })
      .then((res) => should.match_expected(@swig, res.result, path.join(@path, 'string.swig')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.swig')
    @swig.renderFile(lpath, { locals: { author: "Jeff Escalante" } })
      .then((res) => should.match_expected(@swig, res.result, lpath))

  it 'should compile a string', ->
    @swig.compile("<h1>{{ title }}</h1>")
      .then((res) => should.match_expected(@swig, res.result({title: 'Hello!'}), path.join(@path, 'pstring.swig')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.swig')
    @swig.compileFile(lpath)
      .then((res) => should.match_expected(@swig, res.result({title: 'Hello!'}), lpath))

  it.skip 'should client-compile a string', ->
    @swig.compileClient("<h1>{% if foo %}Bar{% endif %}</h1>", {foo: true})
      .then((res) => should.match_expected(@swig, res.result, path.join(@path, 'cstring.swig')))

  it.skip 'should client-compile a file', ->
    lpath = path.join(@path, 'client.swig')
    @swig.compileFileClient(lpath)
      .then((res) => should.match_expected(@swig, res.result, lpath))

  it 'should handle external file requests', ->
    lpath = path.join(@path, 'partial.swig')
    @swig.renderFile(lpath)
      .then((res) => should.match_expected(@swig, res.result, lpath))

  it 'should render with client side helpers', ->
    lpath = path.join(@path, 'client-complex.swig')
    @swig.compileFileClient(lpath)
      .then (res) =>
        tpl_string =  "window = {}; #{@swig.clientHelpers()};\n var tpl = (#{res.result});"
        should.match_expected(@swig, tpl_string, lpath)

describe 'coffeescript', ->

  before ->
    @coffee = accord.load('coffee-script')
    @path = path.join(__dirname, 'fixtures', 'coffee')

  it 'should expose name, extensions, output, and engine', ->
    @coffee.extensions.should.be.an.instanceOf(Array)
    @coffee.output.should.be.a('string')
    @coffee.engine.should.be.ok
    @coffee.name.should.be.ok

  it 'should render a string', ->
    @coffee.render('console.log "test"', { bare: true })
      .then((res) => should.match_expected(@coffee, res.result, path.join(@path, 'string.coffee')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.coffee')
    @coffee.renderFile(lpath)
      .then((res) => should.match_expected(@coffee, res.result, lpath))

  it 'should not be able to compile', ->
    @coffee.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @coffee.render("!   ---@#$$@%#$")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.coffee')
    @coffee.renderFile(lpath, sourcemap: true ).then (res) =>
      res.sourcemap.should.exist
      res.sourcemap.version.should.equal(3)
      res.sourcemap.mappings.length.should.be.above(1)
      res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      res.v2sourcemap.should.exist
      should.match_expected(@coffee, res.result, lpath)

describe 'stylus', ->

  before ->
    @stylus = accord.load('stylus')
    @path = path.join(__dirname, 'fixtures', 'stylus')

  it 'should expose name, extensions, output, and engine', ->
    @stylus.extensions.should.be.an.instanceOf(Array)
    @stylus.output.should.be.a('string')
    @stylus.engine.should.be.ok
    @stylus.name.should.be.ok

  it 'should render a string', ->
    @stylus.render('.test\n  foo: bar')
      .then((res) => should.match_expected(@stylus, res.result, path.join(@path, 'string.styl')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.styl')
    @stylus.renderFile(lpath)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

  it 'should not be able to compile', ->
    @stylus.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should set normal options', ->
    opts =
      paths: ['pluginz']
      foo: 'bar'

    lpath = path.join(@path, 'include1.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

  it 'should correctly import css files', ->
    opts =
      "include css": true

    lpath = path.join(@path, 'include_css.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

  it 'should set vanilla url function', ->
    opts =
      url: 'embedurl'

    lpath = path.join(@path, 'embedurl.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))



  it 'should set url function with options', ->
    opts =
      url:
        name: 'embedurl'
        limit: 10

    lpath = path.join(@path, 'embedurl.styl')
    epath = path.join(@path, 'embedurl-opts.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, epath))

  it 'should set defines', ->
    opts =
      define: { foo: 'bar', baz: 'quux' }

    @stylus.render('.test\n  test: foo', opts)
      .then((res) => should.match_expected(@stylus, res.result, path.join(@path, 'defines.styl')))

  it 'should set raw defines', ->
    opts =
      rawDefine: { rdefine: { blue1: '#0000FF' } }

    lpath = path.join(@path, 'rawdefine.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))


  it 'should set includes', ->
    opts =
      include: 'pluginz'

    lpath = path.join(@path, 'include1.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

  it 'should set multiple includes', ->
    opts =
      include: ['pluginz', 'extra_plugin']

    lpath = path.join(@path, 'include2.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

  it 'should set imports', ->
    opts =
      import: 'pluginz/lib'

    lpath = path.join(@path, 'import1.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

  it 'should set multiple imports', ->
    opts =
      import: ['pluginz/lib', 'pluginz/lib2']

    lpath = path.join(@path, 'import2.styl')
    @stylus.renderFile(lpath, opts)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

  it 'should set plugins', ->
    opts =
      use: (style) ->
        style.define('main-width', 500)

    @stylus.render('.test\n  foo: main-width', opts)
      .then((res) => should.match_expected(@stylus, res.result, path.join(@path, 'plugins1.styl')))

  it 'should set multiple plugins', ->
    opts =
      use: [
        ((style) -> style.define('main-width', 500)),
        ((style) -> style.define('main-height', 200)),
      ]

    @stylus.render('.test\n  foo: main-width\n  bar: main-height', opts)
      .then((res) => should.match_expected(@stylus, res.result, path.join(@path, 'plugins2.styl')))

  it 'should correctly handle errors', ->
    @stylus.render("error('oh noes!')")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should expose sourcemaps', ->
    lpath = path.join(@path, 'basic.styl')
    opts = { sourcemap: true }

    @stylus.renderFile(lpath, opts)
      .tap (res) ->
        res.sourcemap.should.exist
        res.sourcemap.version.should.equal(3)
        res.sourcemap.mappings.length.should.be.above(1)
        res.sourcemap.sourcesContent.length.should.be.above(0)
        # this matches a relative path, really should match absolute
        # res.sourcemap.sources[0].should.equal(lpath)
      .then((res) => should.match_expected(@stylus, res.result, lpath))

describe 'dot', ->

  before ->
    @dot = accord.load('dot')
    @path = path.join(__dirname, 'fixtures', 'dot')

  it 'should expose name, extensions, output, and engine', ->
    @dot.extensions.should.be.an.instanceOf(Array)
    @dot.output.should.be.a('string')
    @dot.engine.should.be.ok
    @dot.name.should.be.ok

  it 'should render a string', ->
    @dot.render("<div>Hi {{=it.name}}!</div><div>{{=it.age || ''}}</div>", { name:"Jake",age:31})
      .then((res) => should.match_expected(@dot, res.result, path.join(@path, 'rstring.dot')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.dot')
    @dot.renderFile(lpath, {name:"Jake",age:31})
      .then((res) => should.match_expected(@dot, res.result, lpath))

  it 'should compile a string', ->
    @dot.compile("<p>{{=it.title}}</p><p>{{=it.message || ''}}</p>")
      .then((res) => should.match_expected(@dot, res.result({ title:"precompilez", message:'wow opts'}), path.join(@path, 'pstring.dot')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.dot')
    @dot.compileFile(lpath)
      .then((res) => should.match_expected(@dot, res.result({title:"precompilez", message:'wow opts'}), lpath))

  # dot doesn't support external file requests out of the box. You have to write your own extension to load snippets.
  # try using the one found here https://github.com/olado/doT/blob/master/examples/withdoT.js
  it 'should handle partial renders', ->
    lpath = path.join(@path, 'partial.dot')
    @dot.renderFile(lpath, { name:"Jake",age:31})
      .then((res) => should.match_expected(@dot, res.result, lpath))

  it 'should client-compile a string', ->
    input = """
      {{? it.name }}
      <div>Oh, I love your name, {{=it.name}}!</div>
      {{?? it.age === 0}}
      <div>Guess nobody named you yet!</div>
      {{??}}
      You are {{=it.age}} and still don't have a name?
      {{?}}
    """
    target = path.join(@path, 'cstring.dot')
    @dot.compileClient(input,  { name:"Jake",age:31} )
      .then((res) => should.match_expected(@dot, res.result, target))

  it 'should client-compile a file', ->
    lpath = path.join(@path, 'client.dot')

    @dot.compileFileClient(lpath, {"name":"Jake","age":31})
      .then((res) => should.match_expected(@dot, res.result, lpath))

  it 'should render with client side helpers', ->
    lpath = path.join(@path, 'client-complex.dot')
    @dot.compileFileClient(lpath)
      .then (res) =>
        tpl_string =  "#{@dot.clientHelpers()}; var tpl = #{res.result}; tpl({'name':'Jake','age':31})"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@dot, tpl, lpath)

  it 'should correctly handle errors', ->
    @dot.render("<div>Hi {{=it.name()}}!</div>")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'ejs', ->

  before ->
    @ejs = accord.load('ejs')
    @path = path.join(__dirname, 'fixtures', 'ejs')

  it 'should expose name, extensions, output, and engine', ->
    @ejs.extensions.should.be.an.instanceOf(Array)
    @ejs.output.should.be.a('string')
    @ejs.engine.should.be.ok
    @ejs.name.should.be.ok

  it 'should render a string', ->
    @ejs.render('<p>ejs yah</p><p><%= foo%></p>', { foo: 'wow opts' })
      .then((res) => should.match_expected(@ejs, res.result, path.join(@path, 'rstring.ejs')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.ejs')
    @ejs.renderFile(lpath, { foo: 'wow opts' })
      .then((res) => should.match_expected(@ejs, res.result, lpath))

  it 'should compile a string', ->
    @ejs.compile("<p>precompilez</p><p><%= foo %></p>")
      .then((res) => should.match_expected(@ejs, res.result({foo: 'wow opts'}), path.join(@path, 'pstring.ejs')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.ejs')
    @ejs.compileFile(lpath)
      .then((res) => should.match_expected(@ejs, res.result({foo: 'wow opts'}), lpath))

  it 'should handle external file requests', ->
    lpath = path.join(@path, 'partial.ejs')
    @ejs.renderFile(lpath)
      .then((res) => should.match_expected(@ejs, res.result, lpath))

  it.skip 'should client-compile a string', ->
    @ejs.compileClient("Woah look, a <%= thing %>")
      .then((res) => should.match_expected(@ejs, res.result, path.join(@path, 'cstring.ejs')))

  # ejs writes the filename to the function, which makes this
  # not work cross-system as expected
  it.skip 'should client-compile a file', ->
    lpath = path.join(@path, 'client.ejs')
    @ejs.compileFileClient(lpath)
      .then((res) => should.match_expected(@ejs, res.result, lpath))

  it 'should render with client side helpers', ->
    lpath = path.join(@path, 'client-complex.ejs')
    @ejs.compileFileClient(lpath)
      .then (res) =>
        tpl_string =  "#{@ejs.clientHelpers()}; var tpl = #{res.result}; tpl({ foo: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@ejs, tpl, lpath)

  it 'should correctly handle errors', ->
    @ejs.render("<%= wow() %>")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'eco', ->

  before ->
    @eco = accord.load('eco')
    @path = path.join(__dirname, 'fixtures', 'eco')

  it 'should expose name, extensions, output, and engine', ->
    @eco.extensions.should.be.an.instanceOf(Array)
    @eco.output.should.be.a('string')
    @eco.engine.should.be.ok
    @eco.name.should.be.ok

  it 'should render a string', ->
    @eco.render('<p>eco yah</p><p><%= @foo %></p>', { foo: 'wow opts' })
      .then((res) =>
        tgt = path.join(@path, 'rstring.eco')
        should.match_expected(@eco, res.result, tgt))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.eco')
    @eco.renderFile(lpath, { foo: 'wow opts' })
      .then((res) => should.match_expected(@eco, res.result, lpath))

  it 'should compile a string', ->
    @eco.compile("<p>precompilez</p><p><%= @foo %></p>").then((res) =>
      tgt = path.join(@path, 'pstring.eco')
      should.match_expected(@eco, res.result({foo: 'wow opts'}), tgt))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.eco')
    @eco.compileFile(lpath)
      .then((res) =>
        should.match_expected(@eco, res.result({foo: 'wow opts'}), lpath))

  it 'should client-compile a string', ->
    @eco.compileClient("Woah look, a <%= thing %>")
      .then((res) =>
        tgt = path.join(@path, 'cstring.eco')
        should.match_expected(@eco, res.result, tgt))

  it 'should client-compile a file', ->
    lpath = path.join(@path, 'client.eco')
    @eco.compileFileClient(lpath)
      .then((res) =>
        should.match_expected(@eco, res.result, lpath))

  it 'should correctly handle errors', ->
    @eco.render("<%= wow() %>")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'markdown', ->

  before ->
    @markdown = accord.load('markdown')
    @path = path.join(__dirname, 'fixtures', 'markdown')

  it 'should expose name, extensions, output, and engine', ->
    @markdown.extensions.should.be.an.instanceOf(Array)
    @markdown.output.should.be.a('string')
    @markdown.engine.should.be.ok
    @markdown.name.should.be.ok

  it 'should render a string', ->
    @markdown.render('hello **world**')
      .then((res) => should.match_expected(@markdown, res.result, path.join(@path, 'string.md')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.md')
    @markdown.renderFile(lpath)
      .then((res) => should.match_expected(@markdown, res.result, lpath))

  it 'should render with options', ->
    lpath = path.join(@path, 'opts.md')
    @markdown.renderFile(lpath, {sanitize: true})
      .then((res) => should.match_expected(@markdown, res.result, lpath))

  it 'should not be able to compile', ->
    @markdown.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

describe 'minify-js', ->

  before ->
    @minifyjs = accord.load('minify-js')
    @path = path.join(__dirname, 'fixtures', 'minify-js')

  it 'should expose name, extensions, output, and engine', ->
    @minifyjs.extensions.should.be.an.instanceOf(Array)
    @minifyjs.output.should.be.a('string')
    @minifyjs.engine.should.be.ok
    @minifyjs.name.should.be.ok

  it 'should minify a string', ->
    @minifyjs.render('var foo = "foobar";\nconsole.log(foo)')
      .then((res) => should.match_expected(@minifyjs, res.result, path.join(@path, 'string.js')))

  it 'should minify a file', ->
    lpath = path.join(@path, 'basic.js')
    @minifyjs.renderFile(lpath)
      .then((res) => should.match_expected(@minifyjs, res.result, lpath))

  it 'should minify with options', ->
    lpath = path.join(@path, 'opts.js')
    @minifyjs.renderFile(lpath, { compress: false })
      .then((res) => should.match_expected(@minifyjs, res.result, lpath))

  it 'should not be able to compile', ->
    @minifyjs.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @minifyjs.render("@#$%#I$$N%NI#$%I$PQ")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.js')
    @minifyjs.renderFile(lpath, sourcemap: true).then (res) =>
      res.sourcemap.version.should.equal(3)
      res.sourcemap.mappings.length.should.be.above(1)
      res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      should.match_expected(@minifyjs, res.result, lpath)

describe 'minify-css', ->

  before ->
    @minifycss = accord.load('minify-css')
    @path = path.join(__dirname, 'fixtures', 'minify-css')

  it 'should expose name, extensions, output, and engine', ->
    @minifycss.extensions.should.be.an.instanceOf(Array)
    @minifycss.output.should.be.a('string')
    @minifycss.engine.should.be.ok
    @minifycss.name.should.be.ok

  it 'should minify a string', ->
    @minifycss.render('.test {\n  foo: bar;\n}')
      .then((res) => should.match_expected(@minifycss, res.result, path.join(@path, 'string.css')))

  it 'should minify a file', ->
    lpath = path.join(@path, 'basic.css')
    @minifycss.renderFile(lpath)
      .then((res) => should.match_expected(@minifycss, res.result, lpath))

  it 'should minify with options', ->
    lpath = path.join(@path, 'opts.css')
    @minifycss.renderFile(lpath, { keepBreaks: true })
      .then((res) => should.match_expected(@minifycss, res.result, lpath))

  it 'should not be able to compile', ->
    @minifycss.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @minifycss.render("FMWT$SP#TPO%M@#@#M!@@@")
      .then(((r) -> r.result.should.equal('')), should.not.exist)

describe 'escape-html', ->
  before ->
    @escapeHtml = accord.load('escape-html')
    @path = path.join(__dirname, 'fixtures', 'escape-html')

  it 'should expose name, extensions, output, and compiler', ->
    @escapeHtml.extensions.should.be.an.instanceOf(Array)
    @escapeHtml.output.should.be.a('string')
    @escapeHtml.engine.should.be.ok
    @escapeHtml.name.should.be.ok

  it 'should render a string', ->
    @escapeHtml.render("<h1>§</h1>")
    .catch(should.not.exist)
    .then((res) =>
      fs.readFileSync(path.join(@path, 'expected', 'string.html'), 'utf8')
        .should.contain(res.result)
    )
  it 'should render a file without escaping anything', ->
    lpath = path.join(@path, 'basic.html')
    @escapeHtml.renderFile(lpath)
      .catch(should.not.exist)
      .then((res) => should.match_expected(@escapeHtml, res.result, lpath))

  it 'should escape content', ->
    lpath = path.join(@path, 'escapable.html')
    @escapeHtml.renderFile(lpath)
      .catch(should.not.exist)
      .then((res) => should.match_expected(@escapeHtml, res.result, lpath))

 describe 'minify-html', ->
  before ->
    @minifyhtml = accord.load('minify-html')
    @path = path.join(__dirname, 'fixtures', 'minify-html')

  it 'should expose name, extensions, output, and engine', ->
    @minifyhtml.extensions.should.be.an.instanceOf(Array)
    @minifyhtml.output.should.be.a('string')
    @minifyhtml.engine.should.be.ok
    @minifyhtml.name.should.be.ok

  it 'should minify a string', ->
    @minifyhtml.render('<div class="hi" id="">\n  <p>hello</p>\n</div>')
      .then((res) => should.match_expected(@minifyhtml, res.result, path.join(@path, 'string.html')))

  it 'should minify a file', ->
    lpath = path.join(@path, 'basic.html')
    @minifyhtml.renderFile(lpath)
      .catch((err) -> console.log err.stack)
      .then((res) => should.match_expected(@minifyhtml, res.result, lpath))

  it 'should minify with options', ->
    lpath = path.join(@path, 'opts.html')
    @minifyhtml.renderFile(lpath, { collapseWhitespace: false })
      .then((res) => should.match_expected(@minifyhtml, res.result, lpath))

  it 'should not be able to compile', ->
    @minifyhtml.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @minifyhtml.render("<<<{@$@#$")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'csso', ->

  before ->
    @csso = accord.load('csso')
    @path = path.join(__dirname, 'fixtures', 'csso')

  it 'should expose name, extensions, output, and engine', ->
    @csso.extensions.should.be.an.instanceOf(Array)
    @csso.output.should.be.a('string')
    @csso.engine.should.be.ok
    @csso.name.should.be.ok

  it 'should minify a string', ->
    @csso.render(".hello { foo: bar; }\n .hello { color: green }")
      .then((res) => should.match_expected(@csso, res.result, path.join(@path, 'string.css')))

  it 'should minify a file', ->
    lpath = path.join(@path, 'basic.css')
    @csso.renderFile(lpath)
      .then((res) => should.match_expected(@csso, res.result, lpath))

  it 'should minify with options', ->
    lpath = path.join(@path, 'opts.css')
    @csso.renderFile(lpath, { restructuring: false })
      .then((res) => should.match_expected(@csso, res.result, lpath))

  it 'should not be able to compile', ->
    @csso.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @csso.render("wow")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'mustache', ->

  before ->
    @mustache = accord.load('mustache')
    @path = path.join(__dirname, 'fixtures', 'mustache')

  it 'should expose name, extensions, output, and engine', ->
    @mustache.extensions.should.be.an.instanceOf(Array)
    @mustache.output.should.be.a('string')
    @mustache.engine.should.be.ok
    @mustache.name.should.be.ok

  it 'should render a string', ->
    @mustache.render("Why hello, {{ name }}!", { name: 'dogeudle' })
      .then((res) => should.match_expected(@mustache, res.result, path.join(@path, 'string.mustache')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.mustache')
    @mustache.renderFile(lpath, { name: 'doge', winner: true })
      .then((res) => should.match_expected(@mustache, res.result, lpath))

  it 'should compile a string', ->
    @mustache.compile("Wow, such {{ noun }}")
      .then((res) => should.match_expected(@mustache, res.result.render({noun: 'compile'}), path.join(@path, 'pstring.mustache')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.mustache')
    @mustache.compileFile(lpath)
      .then((res) => should.match_expected(@mustache, res.result.render({name: 'foo'}), lpath))

  it 'client compile should work', ->
    lpath = path.join(@path, 'client-complex.mustache')
    @mustache.compileFileClient(lpath)
      .then (res) =>
        tpl_string =  "#{@mustache.clientHelpers()}; var tpl = #{res.result} tpl.render({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@mustache, tpl, lpath)

  it 'should handle partials', ->
    lpath = path.join(@path, 'partial.mustache')
    @mustache.renderFile(lpath, { foo: 'bar', partials: { partial: 'foo {{ foo }}' } })
      .then((res) => should.match_expected(@mustache, res.result, lpath))

  it 'should correctly handle errors', ->
    @mustache.render("{{# !@{!# }}")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'dogescript', ->

  before ->
    @doge = accord.load('dogescript')
    @path = path.join(__dirname, 'fixtures', 'dogescript')

  it 'should expose name, extensions, output, and engine', ->
    @doge.extensions.should.be.an.instanceOf(Array)
    @doge.output.should.be.a('string')
    @doge.engine.should.be.ok
    @doge.name.should.be.ok

  it 'should render a string', ->
    @doge.render("console dose loge with 'wow'", { beautify: true })
      .then((res) => should.match_expected(@doge, res.result, path.join(@path, 'string.djs')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.djs')
    @doge.renderFile(lpath, { trueDoge: true })
      .then((res) => should.match_expected(@doge, res.result, lpath))

  it 'should not be able to compile', ->
    @doge.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  # it turns out that it's impossible for dogescript to throw an error
  # which, honestly, is how it should be. so no test here.

describe 'handlebars', ->

  before ->
    @handlebars = accord.load('handlebars')
    @path = path.join(__dirname, 'fixtures', 'handlebars')

  it 'should expose name, extensions, output, and engine', ->
    @handlebars.extensions.should.be.an.instanceOf(Array)
    @handlebars.output.should.be.a('string')
    @handlebars.engine.should.be.ok
    @handlebars.name.should.be.ok

  it 'should render a string', ->
    @handlebars.render('Hello there {{ name }}', { name: 'homie' })
      .then((res) => should.match_expected(@handlebars, res.result, path.join(@path, 'rstring.hbs')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.hbs')
    @handlebars.renderFile(lpath, { compiler: 'handlebars' })
      .then((res) => should.match_expected(@handlebars, res.result, lpath))

  it 'should compile a string', ->
    @handlebars.compile('Hello there {{ name }}')
      .then((res) => should.match_expected(@handlebars, res.result({ name: 'my friend' }), path.join(@path, 'pstring.hbs')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.hbs')
    @handlebars.compileFile(lpath)
      .then((res) => should.match_expected(@handlebars, res.result({ friend: 'r kelly' }), lpath))

  it 'should client-compile a string', ->
    @handlebars.compileClient("Here comes the {{ thing }}")
      .then((res) => should.match_expected(@handlebars, res.result, path.join(@path, 'cstring.hbs')))

  it 'should client-compile a file', ->
    lpath = path.join(@path, 'client.hbs')
    @handlebars.compileFileClient(lpath)
      .then((res) => should.match_expected(@handlebars, res.result, lpath))

  it 'should handle external file requests', ->
    lpath = path.join(@path, 'partial.hbs')
    @handlebars.renderFile(lpath, { partials: { foo: "<p>hello from a partial!</p>" }})
      .then((res) => should.match_expected(@handlebars, res.result, lpath))

  it 'should render with client side helpers', ->
    lpath = path.join(@path, 'client-complex.hbs')
    @handlebars.compileFileClient(lpath)
      .then (res) =>
        tpl_string =  "#{@handlebars.clientHelpers()}; var tpl = #{res.result}; tpl({ wow: 'local' })"
        tpl = eval.call(global, tpl_string)
        should.match_expected(@handlebars, tpl, lpath)

  it 'should correctly handle errors', ->
    @handlebars.render("{{# !@{!# }}")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'scss', ->

  before ->
    @scss = accord.load('scss')
    @path = path.join(__dirname, 'fixtures', 'scss')

  it 'should expose name, extensions, output, and engine', ->
    @scss.extensions.should.be.an.instanceOf(Array)
    @scss.output.should.be.a('string')
    @scss.engine.should.be.ok
    @scss.name.should.be.ok

  it 'should render a string', ->
    @scss.render("$wow: 'red'; foo { bar: $wow; }")
      .then((res) => should.match_expected(@scss, res.result, path.join(@path, 'string.scss')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.scss')
    @scss.renderFile(lpath, { trueDoge: true })
      .then((res) => should.match_expected(@scss, res.result, lpath))

  it 'should include external files', ->
    lpath = path.join(@path, 'external.scss')
    @scss.renderFile(lpath, { includePaths: [@path] })
      .then((res) => should.match_expected(@scss, res.result, lpath))

  it 'should not be able to compile', ->
    @scss.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @scss.render("!@##%#$#^$")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate a sourcemap', ->
    lpath = path.join(@path, 'basic.scss')
    @scss.renderFile(lpath, { sourcemap: true })
      .tap (res) ->
        res.sourcemap.version.should.equal(3)
        res.sourcemap.mappings.length.should.be.above(1)
        res.sourcemap.sources[0].should.equal(lpath)
        res.sourcemap.sourcesContent.length.should.be.above(0)
      .then((res) => should.match_expected(@scss, res.result, lpath))

  it 'should generate a sourcemap with correct sources', ->
    lpath = path.join(@path, 'external.scss')
    mixinpath = path.join(@path, '_mixin_lib.scss')
    @scss.renderFile(lpath, { sourcemap: true })
      .tap (res) ->
        res.sourcemap.version.should.equal(3)
        res.sourcemap.mappings.length.should.be.above(1)
        res.sourcemap.sources.length.should.equal(2)
        res.sourcemap.sources[0].should.equal(lpath)
        res.sourcemap.sources[1].should.equal(mixinpath)
        res.sourcemap.sourcesContent.length.should.equal(2)
      .then((res) => should.match_expected(@scss, res.result, lpath))

  it 'should generate a sourcemap with correct relative sources', ->
    lpath = path.join(@path, 'external.scss')
    mixinpath = path.join(@path, '_mixin_lib.scss')
    @scss.renderFile(lpath, { sourcemap: lpath })
      .tap (res) ->
        res.sourcemap.version.should.equal(3)
        res.sourcemap.mappings.length.should.be.above(1)
        res.sourcemap.sources.length.should.equal(2)
        res.sourcemap.sources[0].should.equal('external.scss')
        res.sourcemap.sources[1].should.equal('_mixin_lib.scss')
        res.sourcemap.sourcesContent.length.should.equal(2)
      .then((res) => should.match_expected(@scss, res.result, lpath))

describe 'less', ->

  before ->
    @less = accord.load('less')
    @path = path.join(__dirname, 'fixtures', 'less')

  it 'should expose name, extensions, output, and engine', ->
    @less.extensions.should.be.an.instanceOf(Array)
    @less.output.should.be.a('string')
    @less.engine.should.be.ok
    @less.name.should.be.ok

  it 'should render a string', ->
    @less.render(".foo { width: 100 + 20 }")
      .then((res) => should.match_expected(@less, res.result, path.join(@path, 'string.less')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.less')
    @less.renderFile(lpath, { trueDoge: true })
      .then((res) => should.match_expected(@less, res.result, lpath))

  it 'should include external files', ->
    lpath = path.join(@path, 'external.less')
    @less.renderFile(lpath, { paths: [@path] })
      .then((res) => should.match_expected(@less, res.result, lpath))

  it 'should not be able to compile', ->
    @less.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle parse errors', ->
    @less.render("!@##%#$#^$")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should correctly handle tree resolution errors', ->
    @less.render('''
    .foo {
      .notFound()
    }
    ''')
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.less')
    @less.renderFile(lpath, sourcemap: true).then (res) =>
      res.sourcemap.version.should.equal(3)
      res.sourcemap.mappings.length.should.be.above(1)
      res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      should.match_expected(@less, res.result, lpath)

  it 'should accept sourcemap overrides', ->
    lpath = path.join(@path, 'basic.less')
    @less.renderFile(lpath, { sourceMap: { sourceMapBasepath: 'test/fixtures/less/basic.less' }, filename: 'basic.less' }).then (res) =>
      res.sourcemap.version.should.equal(3)
      res.sourcemap.sources[0].should.equal('basic.less')
      should.not.exist(res.sourcemap.sourcesContent)

describe 'coco', ->

  before ->
    @coco = accord.load('coco')
    @path = path.join(__dirname, 'fixtures', 'coco')

  it 'should expose name, extensions, output, and engine', ->
    @coco.extensions.should.be.an.instanceOf(Array)
    @coco.output.should.be.a('string')
    @coco.engine.should.be.ok
    @coco.name.should.be.ok

  it 'should render a string', ->
    @coco.render("function test\n  console.log('foo')", { bare: true })
      .then((res) => should.match_expected(@coco, res.result, path.join(@path, 'string.co')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.co')
    @coco.renderFile(lpath)
      .then((res) => should.match_expected(@coco, res.result, lpath))

  it 'should not be able to compile', ->
    @coco.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @coco.render("!! ---  )I%$_(I(YRTO")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'livescript', ->

  before ->
    @livescript = accord.load('LiveScript')
    @path = path.join(__dirname, 'fixtures', 'livescript')

  it 'should expose name, extensions, output, and engine', ->
    @livescript.extensions.should.be.an.instanceOf(Array)
    @livescript.output.should.be.a('string')
    @livescript.engine.should.be.ok
    @livescript.name.should.be.ok

  it 'should render a string', ->
    @livescript.render("test = ~> console.log('foo')", { bare: true })
      .then((res) => should.match_expected(@livescript, res.result, path.join(@path, 'string.ls')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.ls')
    @livescript.renderFile(lpath)
      .then((res) => should.match_expected(@livescript, res.result, lpath))

  it 'should not be able to compile', ->
    @livescript.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @livescript.render("!! ---  )I%$_(I(YRTO")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'typescript', ->

  before ->
    @typescript = accord.load('typescript', undefined, 'typescript-compiler')
    @path = path.join(__dirname, 'fixtures', 'typescript')

  it 'should expose name, extensions, output, and engine', ->
    @typescript.extensions.should.be.an.instanceOf(Array)
    @typescript.output.should.be.a('string')
    @typescript.engine.should.be.ok
    @typescript.name.should.be.ok

  it 'should render a string', ->
    @typescript.render("var n:number = 42; console.log(n)", { bare: true })
      .then((res) => should.match_expected(@typescript, res.result, path.join(@path, 'string.ts')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.ts')
    @typescript.renderFile(lpath)
      .then((res) => should.match_expected(@typescript, res.result, lpath))

  it 'should not be able to compile', ->
    @typescript.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @typescript.render("!! ---  )I%$_(I(YRTO")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'myth', ->

  before ->
    @myth = accord.load('myth')
    @path = path.join(__dirname, 'fixtures', 'myth')

  it 'should expose name, extensions, output, and engine', ->
    @myth.extensions.should.be.an.instanceOf(Array)
    @myth.output.should.be.a('string')
    @myth.engine.should.be.ok
    @myth.name.should.be.ok

  it 'should render a string', ->
    @myth.render(".foo { transition: all 1s ease; }")
      .then((res) => should.match_expected(@myth, res.result, path.join(@path, 'string.myth')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.myth')
    @myth.renderFile(lpath)
      .then((res) => should.match_expected(@myth, res.result, lpath))

  it 'should not be able to compile', ->
    @myth.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @myth.render("!! ---  )I%$_(I(YRTO")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.myth')
    @myth.renderFile(lpath, sourcemap: true).then (res) =>
      res.sourcemap.should.be.an('object')
      res.sourcemap.version.should.equal(3)
      res.sourcemap.sources.length.should.be.above(1)
      res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      should.match_expected(@myth, res.result, lpath)

describe 'haml', ->

  before ->
    @haml = accord.load('haml')
    @path = path.join(__dirname, 'fixtures', 'haml')

  it 'should expose name, extensions, output, and engine', ->
    @haml.extensions.should.be.an.instanceOf(Array)
    @haml.output.should.be.a('string')
    @haml.engine.should.be.ok
    @haml.name.should.be.ok

  it 'should render a string', ->
    @haml.render('%div.foo= "Whats up " + name', { name: 'mang' })
      .then((res) => should.match_expected(@haml, res.result, path.join(@path, 'rstring.haml')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.haml')
    @haml.renderFile(lpath, { compiler: 'haml' })
      .then((res) => should.match_expected(@haml, res.result, lpath))

  it 'should compile a string', ->
    @haml.compile('%p= "Hello there " + name')
      .then((res) => should.match_expected(@haml, res.result({ name: 'my friend' }), path.join(@path, 'pstring.haml')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'precompile.haml')
    @haml.compileFile(lpath)
      .then((res) => should.match_expected(@haml, res.result({ friend: 'doge' }), lpath))

  it 'should not support client compiles', ->
    @haml.compileClient("%p= 'Here comes the ' + thing")
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @haml.render("%p= wow()")
      .then(should.not.exist)
      .catch((x) -> x)

describe 'marc', ->

  before ->
    @marc = accord.load('marc')
    @path = path.join(__dirname, 'fixtures', 'marc')

  it 'should expose name, extensions, output, and engine', ->
    @marc.extensions.should.be.an.instanceOf(Array)
    @marc.output.should.be.a('string')
    @marc.engine.should.be.ok
    @marc.name.should.be.ok

  it 'should render a string', ->
    @marc.render(
      'I am using __markdown__ with {{label}}!'
      data:
        label: 'marc'
    ).catch(
      should.not.exist
    ).then((res) =>
      should.match_expected(@marc, res.result, path.join(@path, 'basic.md'))
    )

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.md')
    @marc.renderFile(lpath, data: {label: 'marc'})
      .then((res) => should.match_expected(@marc, res.result, lpath))

  it 'should not be able to compile', ->
    @marc.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

describe 'toffee', ->

  before ->
    @toffee = accord.load('toffee')
    @path = path.join(__dirname, 'fixtures', 'toffee')

  it 'should expose name, extensions, output, and compiler', ->
    @toffee.extensions.should.be.an.instanceOf(Array)
    @toffee.output.should.be.a('string')
    @toffee.engine.should.be.ok
    @toffee.name.should.be.ok

  it 'should render a string', ->
    @toffee.render('''
      {#
        for supply in supplies {:<li>#{supply}</li>:}
      #}
      ''',
        supplies: ['mop', 'trash bin', 'flashlight']
      ).catch(should.not.exist)
      .then((res) => should.match_expected(@toffee, res.result, path.join(@path, 'basic.toffee')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.toffee')
    @toffee.renderFile(lpath, {supplies: ['mop', 'trash bin', 'flashlight']})
      .catch(should.not.exist)
      .then((res) => should.match_expected(@toffee, res.result, lpath))

  it 'should compile a string', ->
    @toffee.compile('''
      {#
        for supply in supplies {:<li>#{supply}</li>:}
      #}
      ''',
        supplies: ['mop', 'trash bin', 'flashlight']
      ).then((res) => should.match_expected(@toffee, res.result, path.join(@path, 'template.toffee')))

  it 'should compile a file', ->
    lpath = path.join(@path, 'template.toffee')
    @toffee.compileFile(lpath, {supplies: ['mop', 'trash bin', 'flashlight']})
      .then((res) => should.match_expected(@toffee, res.result, lpath))

  it 'should client-compile a string', ->
    @toffee.compileClient('''
      {#
        for supply in supplies {:<li>#{supply}</li>:}
      #}
      ''', {})
      .then((res) => should.match_expected(@toffee, res.result, path.join(@path, 'my_templates.toffee')))

  it 'should client-compile a string without headers', ->
    @toffee.compileClient('''
      {#
        for supply in supplies {:<li>#{supply}</li>:}
      #}
      ''',
      headers: false
      ).then((res) => should.match_expected(@toffee, res.result, path.join(@path, 'no-header-templ.toffee')))

  it 'should client-compile a file', ->
    lpath = path.join(path.relative(process.cwd(), @path), 'my_templates-2.toffee')
    @toffee.compileFileClient(lpath, {})
      .then((res) => should.match_expected(@toffee, res.result, lpath))

  it 'should handle errors', ->
    @toffee.render('''
      {#
        for supply in supplies {:<li>#{supply}</li>
      #}
      ''', {})
      .then(should.not.exist)
      .catch((x) -> x)

describe 'babel', ->
  before ->
    @babel = accord.load('babel')
    @path = path.join(__dirname, 'fixtures', 'babel')

  it 'should expose name, extensions, output, and compiler', ->
    @babel.extensions.should.be.an.instanceOf(Array)
    @babel.output.should.be.a('string')
    @babel.engine.should.be.ok
    @babel.name.should.be.ok

  it 'should render a string', ->
    p = path.join(@path, 'string.js')
    @babel.render("console.log('foo');", { presets: ['es2015'] }).catch(should.not.exist)
      .then((res) => should.match_expected(@babel, res.result, p))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.js')
    @babel.renderFile(lpath, { presets: ['es2015'] })
      .catch(should.not.exist)
      .then((res) => should.match_expected(@babel, res.result, lpath))

  it 'should not be able to compile', ->
    @babel.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @babel.render("!   ---@#$$@%#$")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.js')
    @babel.renderFile(lpath, { presets: ['es2015'], sourcemap: true }).then (res) =>
      res.sourcemap.should.exist
      res.sourcemap.version.should.equal(3)
      res.sourcemap.mappings.length.should.be.above(1)
      res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      should.match_expected(@babel, res.result, lpath)

  it 'should not allow keys outside of babel\'s options', ->
    lpath = path.join(@path, 'basic.js')
    @babel.renderFile(lpath, { presets: ['es2015'], foobar: 'wow' })
      .catch(should.not.exist)
      .then((res) => should.match_expected(@babel, res.result, lpath))

describe 'buble', ->
  before ->
    @buble = accord.load('buble')
    @path = path.join(__dirname, 'fixtures', 'buble')

  it 'should expose name, extensions, output, and compiler', ->
    @buble.extensions.should.be.an.instanceOf(Array)
    @buble.output.should.be.a('string')
    @buble.engine.should.be.ok
    @buble.name.should.be.ok

  it 'should render a string', ->
    p = path.join(@path, 'string.js')
    @buble.render("console.log('foo');").catch(should.not.exist)
      .then((res) => should.match_expected(@buble, res.result, p))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.js')
    @buble.renderFile(lpath)
      .catch(should.not.exist)
      .then((res) => should.match_expected(@buble, res.result, lpath))

  it 'should not be able to compile', ->
    @buble.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @buble.render("!   ---@#$$@%#$")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.js')
    @buble.renderFile(lpath).then (res) =>
      res.sourcemap.should.exist
      res.sourcemap.version.should.equal(3)
      res.sourcemap.mappings.length.should.be.above(1)
      res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      should.match_expected(@buble, res.result, lpath)

describe 'jsx', ->

  before ->
    @jsx = accord.load('jsx')
    @path = path.join(__dirname, 'fixtures', 'jsx')

  it 'should expose name, extensions, output, and engine', ->
    @jsx.extensions.should.be.an.instanceOf(Array)
    @jsx.output.should.be.a('string')
    @jsx.engine.should.be.ok
    @jsx.name.should.be.ok

  it 'should render a string', ->
    @jsx.render('<div className="foo">{this.props.bar}</div>', { bare: true })
      .then((res) => should.match_expected(@jsx, res.result, path.join(@path, 'string.jsx')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.jsx')
    @jsx.renderFile(lpath)
      .then((res) => should.match_expected(@jsx, res.result, lpath))

  it 'should not be able to compile', ->
    @jsx.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

  it 'should correctly handle errors', ->
    @jsx.render("!   ---@#$$@%#$")
      .then(should.not.exist)
      .catch((x) -> x)

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.jsx')
    @jsx.renderFile(lpath, sourcemap: true ).then (res) =>
      res.sourcemap.should.exist
      res.sourcemap.version.should.equal(3)
      res.sourcemap.mappings.length.should.be.above(1)
      res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      should.match_expected(@jsx, res.result, lpath)

describe 'cjsx', ->

  before ->
    @cjsx = accord.load('cjsx')
    @path = path.join(__dirname, 'fixtures', 'cjsx')

  it 'should expose name, extensions, output, and engine', ->
    @cjsx.extensions.should.be.an.instanceOf(Array)
    @cjsx.output.should.be.a('string')
    @cjsx.engine.should.be.ok
    @cjsx.name.should.be.ok

  it 'should render a string', ->
    @cjsx.render('<div className="foo"></div>')
      .then((res) => should.match_expected(@cjsx, res.result, path.join(@path, 'string.cjsx')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.cjsx')
    @cjsx.renderFile(lpath)
      .then((res) => should.match_expected(@cjsx, res.result, lpath))

  it 'should not be able to compile', ->
    @cjsx.compile()
      .then(((r) -> should.not.exist(r)), ((r) -> should.exist(r)))

describe 'postcss', ->

  before ->
    @postcss = accord.load('postcss')
    @path = path.join(__dirname, 'fixtures', 'postcss')

  it 'should expose name, extensions, output, and engine', ->
    @postcss.extensions.should.be.an.instanceOf(Array)
    @postcss.output.should.be.a('string')
    @postcss.engine.should.be.ok
    @postcss.name.should.be.ok

  it 'should render a string', ->
    @postcss.render('.test { color: green; }')
      .then((res) => should.match_expected(@postcss, res.result, path.join(@path, 'string.css')))

  it 'should render a file', ->
    lpath = path.join(@path, 'basic.css')
    @postcss.renderFile(lpath)
      .then((res) => should.match_expected(@postcss, res.result, lpath))

  it 'should render a file with plugin', ->
    lpath = path.join(@path, 'var.css')
    varsPlugin = require('postcss-simple-vars')
    @postcss.renderFile(lpath, {use: [varsPlugin]})
      .then((res) => should.match_expected(@postcss, res.result, lpath))

  it 'should generate sourcemaps', ->
    lpath = path.join(@path, 'basic.css')
    opts = {map: true}
    @postcss.renderFile(lpath, opts).then (res) =>
      res.sourcemap.should.exist
      res.sourcemap.version.should.equal(3)
      res.sourcemap.mappings.length.should.be.above(1)
      # postcss converts the absolute path to a relative path
      # res.sourcemap.sources[0].should.equal(lpath)
      res.sourcemap.sourcesContent.length.should.be.above(0)
      should.match_expected(@postcss, res.result, lpath)

  it 'should correctly handle errors', ->
    @postcss.render('.test { ')
      .then(should.not.exist)
      .catch((x) -> x)
