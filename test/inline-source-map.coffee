should = require 'should'
path = require 'path'
accord = require '../'
Job = require '../lib/job'

describe 'inline-source-map', ->
  before ->
    @inlineSourceMap = accord.load('inline-source-map')

  it 'should compose with existing sourcemaps', (done) ->
    job = new Job(
      text: 'console.log("test");\n'
      sourceMap:
        version: 3,
        sourceRoot: '',
        sources: ['index.coffee'],
        sourcesContent: ['if true then console.log "test"\n']
        names: [],
        mappings: 'AAAa,QAAQ,IAAI'
    )
    @inlineSourceMap.render(job).done (res) ->
      res.text.should.eql('''
        console.log("test");
        //# sourceMappingURL=data:application/json;base64,eyJtYXBwaW5ncyI6IkFBQWEsUUFBUSxJQUFJIiwibmFtZXMiOltdLCJzb3VyY2VzIjpbImluZGV4LmNvZmZlZSJdLCJzb3VyY2VzQ29udGVudCI6WyJpZiB0cnVlIHRoZW4gY29uc29sZS5sb2cgXCJ0ZXN0XCJcbiJdLCJ2ZXJzaW9uIjozfQ==\n
      ''')
      (res.sourceMap.mappings?).should.eql(false)
      done()

  it 'should compose with existing sourcemaps', (done) ->
    coffee = accord.load('coffee')
    minifyJS = accord.load('minify-js')
    coffee.render(
      '''
      if true then console.log "test"
      blah = -> 42
      '''
      bare: true
      filename: 'index.coffee'
    ).then((res) ->
      res.text.should.eql('''
        var blah;

        if (true) {
          console.log("test");
        }

        blah = function() {
          return 42;
        };\n
      ''')
      res.sourceMap.sourcesContent.should.eql([
        'if true then console.log "test"\nblah = -> 42'
      ])
      res.sourceMap.mappings.should.eql(
        'AAAA,IAAA,IAAA;;AAAA,IAAG,IAAH;AAAa,EAAA,OAAO,CAAC,GAAR,CAAY,MAAZ,' +
        'CAAA,CAAb;CAAA;;AAAA,IACA,GAAO,SAAA,GAAA;SAAG,GAAH;AAAA,CADP,CAAA'
      )
      return res
    ).then(
      minifyJS.render
    ).then((res) ->
      res.text.should.eql(
        'var blah;console.log("test"),blah=function(){return 42};\n'
      )
      res.sourceMap.sourcesContent.should.eql([
        'if true then console.log "test"\nblah = -> 42'
      ])
      res.sourceMap.mappings.should.eql(
        'AAAA,GAAA,KAAa,SAAQ,IAAI,QAAzB,KACO,iBAAG'
      )
      return res
    ).then(
      @inlineSourceMap.render
    ).done (res) ->
      res.text.should.eql('''
        var blah;console.log("test"),blah=function(){return 42};
        //# sourceMappingURL=data:application/json;base64,eyJmaWxlIjoiaW5kZXgiLCJtYXBwaW5ncyI6IkFBQUEsR0FBQSxLQUFhLFNBQVEsSUFBSSxRQUF6QixLQUNPLGlCQUFHIiwibmFtZXMiOltdLCJzb3VyY2VzIjpbImluZGV4Il0sInNvdXJjZXNDb250ZW50IjpbImlmIHRydWUgdGhlbiBjb25zb2xlLmxvZyBcInRlc3RcIlxuYmxhaCA9IC0+IDQyIl0sInZlcnNpb24iOjN9\n
      ''')
      (res.sourceMap.mappings?).should.eql(false)
      done()
