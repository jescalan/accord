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
      res.text.should.eql("""
      console.log("test");
      //# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyJpbmRleC5jb2ZmZWUiXSwic291cmNlc0NvbnRlbnQiOlsiaWYgdHJ1ZSB0aGVuIGNvbnNvbGUubG9nIFwidGVzdFwiXG4iXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQWEsUUFBUSxJQUFJIn0=

      """)
      (res.sourceMap.mappings?).should.eql(false)
      done()
