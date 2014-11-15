should = require 'should'
path = require 'path'
accord = require '../'
Job = require '../lib/job'

describe 'minify-js', ->
  before ->
    @minifyjs = accord.load('minify-js')
    @path = path.join(__dirname, 'fixtures', 'minify-js')

  it 'should expose name, extensions, output, and engine', ->
    @minifyjs.extensions.should.be.an.instanceOf(Array)
    @minifyjs.output.should.be.type('string')
    @minifyjs.engine.should.be.ok
    @minifyjs.name.should.be.ok

  it 'should minify a string', (done) ->
    @minifyjs.render('var foo = "foobar";\nconsole.log(foo)')
      .done((res) => should.match_expected(@minifyjs, res, path.join(@path, 'string.js'), done))

  it 'should minify a file', (done) ->
    lpath = path.join(@path, 'basic.js')
    @minifyjs.renderFile(lpath)
      .done((res) => should.match_expected(@minifyjs, res, lpath, done))

  it 'should minify with options', (done) ->
    lpath = path.join(@path, 'opts.js')
    @minifyjs.renderFile(lpath, { compress: false })
      .done((res) => should.match_expected(@minifyjs, res, lpath, done))

  it 'should not be able to compile', (done) ->
    @minifyjs.compile()
      .done(((r) -> should.not.exist(r); done()), ((r) -> should.exist(r); done()))

  it 'should correctly handle errors', (done) ->
    @minifyjs.render("@#$%#I$$N%NI#$%I$PQ")
      .done(should.not.exist, (-> done()))

  it 'should support sourcemaps', (done) ->
    @minifyjs.render("if (true) {console.log()}").done (res) ->
      res.text.should.eql('console.log();\n//# sourceMappingURL=out.js.map\n')
      res.sourceMap.mappings.should.eql('AAAWA,QAAQC')
      done()

  it 'should compose with existing sourcemaps', (done) ->
    job = new Job(
      text: 'if (true) {\n  console.log("test");\n}\n'
      sourceMap:
        version: 3,
        file: '',
        sourceRoot: '',
        sources: [ '' ],
        names: [],
        mappings: 'AAAA,IAAG,IAAH;AAAa,EAAA,OAAO,CAAC,GAAR,CAAY,MAAZ,CAAA,CAAb;CAAA'
    )
    @minifyjs.render(job).done (res) ->
      res.text.should.eql('console.log("test");\n//# sourceMappingURL=out.js.map\n')
      res.sourceMap.mappings.should.eql('AAAa,QAAQ,IAAI')
      done()
