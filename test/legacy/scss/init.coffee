polytest = require './config'

# 2.x legacy tests
polytest.v2.install ->
  polytest.v2.run().stderr.pipe(process.stdout)
  polytest.v2.run().stdout.pipe(process.stdout)