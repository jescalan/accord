var chai   = require('chai'),
    W      = require('when'),
    _      = require('lodash'),
    path   = require('path'),
    fs     = require('fs'),
    util   = require('util'),
    accord = require('../..');

global.should = chai.should();
global.accord = accord;
global.W = W;
global._ = _;

global.should.match_expected = function(compiler, content, epath, done) {
  switch (compiler.output) {
    case 'html':
      var parser = new (require('parse5').Parser);
      parser = parser.parseFragment.bind(parser);
      break;
    case 'css':
      var parser = require ('css-parse');
      break;
    case 'js':
      var parser = (require('acorn')).parse;
      break;
    default:
      var parser = function(str){ return str };
  }

  var expected_path = path.join(
      path.dirname(epath),
      'expected',
      path.basename(epath, compiler.extensions[0]) + compiler.output
    );

  fs.existsSync(expected_path).should.be.ok

  var expected = parser(fs.readFileSync(expected_path, 'utf8'));
  var results = parser(content);

  util.inspect(expected).should.eql(util.inspect(results));
  return done();
}