transferSourceMap = require('multi-stage-sourcemap').transfer

###*
 * This represents a single job that has been returned by and/or is being given
   to an adapter.
###
class Job
  ###*
   * The text resulting from, or being given to the Adapter. This is read-only
     because the text and the sourcemap are tied together and the sourcemap
     needs to be updated or removed whenever the text changes. Use setText to
     change this property.
   * @readonly
  ###
  text: ''

  ###*
   * The sourcemap that represents all transformations applied to the text. This
     is a version 3 sourcemap and contains the sourcesContent property to record
     the first known content of Job.text This is read-only because the text and
     the sourcemap are tied together and the sourcemap needs to be updated or
     removed whenever the text changes. Use setText to change this property.
   * @readonly
  ###
  sourceMap: undefined

  ###*
   * @param {Object|String|Job} job
   * @param {Object|Boolean} [options.sourceMap] A sourcemap object, according
     to version 3 of the spec.
  ###
  constructor: (job) ->
    @sourceMap = {}
    if typeof job is 'string'
      # if we are just passed a string, make it into a proper job object
      job = text: job

    job.text ?= ''
    @setText(job.text, job.sourceMap)

  ###*
   * Add a SourceMap to the object
   * @param {String} text [description]
   * @param {Object} sourceMap The sourcemap representing the change from the
     old text to the new text that is being passed in. If omitted, we remove the
     sourcemap from the object. Without this removal, a sourcemap from a
     previous operation could be erroneously associated with the new text (if
     the adapter adapter producing the new text doesn't support sourcemaps).
  ###
  setText: (text, sourceMap) =>
    # make sure we're actually changing the text
    if text isnt @text
      if sourceMap?
        if @sourceMap.mappings
          @sourceMap = JSON.parse(transferSourceMap(
            fromSourceMap: sourceMap
            toSourceMap: @sourceMap
          ))
        else
          @sourceMap = sourceMap
          @sourceMap.sourcesContent = [text]
      else
        @sourceMap.sourcesContent = [text]
        delete @sourceMap.mappings

      # we can strip the trailing whitespace without changing the sourcemap
      @text = text.replace(/\s*$/, '\n')
      #console.log @sourceMap
    return this

  toString: => @text

  isJob: -> true

module.exports = Job
