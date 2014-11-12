Adapter = require '../adapter_base'
W       = require 'when'

class Marc extends Adapter
  name: 'marc'
  extensions: ['md']
  output: 'html'
  supportedEngines: ['marc']

  _render: (str, options) ->
    # marc mutates the compiler, so we need to keep the original fresh
    base = @engine()

    # use marc's functions to configure the compiler
    base.set(k, v) for k, v of options['data']
    delete options['data']
    base.partial(k, v) for k, v of options['partial']
    delete options['partial']
    base.filter(k, v) for k, v of options['filter']
    delete options['filter']

    # all the remaining options are options for marked
    base.config options
    W.resolve base(str, true)

module.exports = Marc
