path = require 'path'
fs = require 'fs'

module.exports = (should) ->

  should.match_expected = (compiler, content, epath) ->

    parser = switch compiler.output
      when 'html'
        HP = require('htmlparser')
        handler = new HP.DefaultHandler
        p = new HP.Parser(handler)
        ((c) -> p.parseComplete.call(p, c); handler.dom)
      when 'css' then require ('css-parse')
      when 'js' then (require('acorn')).parse

    expected_path = path.join(path.dirname(epath), 'expected', "#{path.basename(epath, compiler.extensions[0])}#{compiler.output}")
    fs.existsSync(expected_path).should.be.ok
    expected = parser(fs.readFileSync(expected_path, 'utf8'))
    results = parser(content)
    expected.should.eql(results)
