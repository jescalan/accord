Adapter = require '../adapter_base'
W       = require 'when'
_       = require 'lodash'

class MinifyHTML extends Adapter
  name: 'minify-html'
  extensions: ['html']
  output: 'html'
  supportedEngines: ['html-minifier']

  ###*
   * I think that you could cause this to not be isolated by using the minifyCSS
     option and then making that import stylesheets, but I'm not even sure if
     MinifyHTML would support that...
  ###
  isolated: true

  _render: (job, options) ->
    options = _.defaults options,
      removeComments: true
      collapseWhitespace: true
      removeEmptyAttributes: true

    W.try(@engine.minify, job.text, options).then(job.setText)

module.exports = MinifyHTML
