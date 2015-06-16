Polytest = require 'polytest'

exports.v2 = new Polytest
  cmd: "mocha #{process.cwd()}/test/legacy/scss/2.x/test.coffee"
  pkg: 'test/legacy/scss/2.x/package.json'