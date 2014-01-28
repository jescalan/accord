path = require 'path'
fs = require 'fs'
util = require 'util'

module.exports = (should) ->

  should.match_expected = (compiler, content, epath, done) ->
    parser = switch compiler.output
      when 'html'
        parser = new (require('parse5').Parser)
        parser.parseFragment.bind(parser)
      when 'css' then require ('css-parse')
      when 'js' then (require('acorn')).parse

    expected_path = path.join(path.dirname(epath), 'expected', "#{path.basename(epath, compiler.extensions[0])}#{compiler.output}")
    fs.existsSync(expected_path).should.be.ok
    expected = parser(fs.readFileSync(expected_path, 'utf8'))
    results = parser(content)
    util.inspect(expected).should.eql(util.inspect(results))
    done()
