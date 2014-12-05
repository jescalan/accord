transferSourceMap = require('multi-stage-sourcemap').transfer

###*
 * This represents a single job that has been returned by and/or is being given
   to an adapter.
###
class Job
  ###*
   * A list of all the source files that were required to run this job,
     including the input file (if it was specified in the filename option)
   * @type {Array}
  ###
  dependancies: undefined

  ###*
   * The text resulting from, or being given to the Adapter. This is read-only
     because the text and the sourcemap are tied together and the sourcemap
     needs to be updated or removed whenever the text changes. Use setText to
     change this property.
   * @readonly
  ###
  text: undefined

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
    @startTime = process.hrtime()
    @dependancies = job.dependancies ?= []
    if job.options?.filename? then @dependancies.push(job.options.filename)

    if typeof job is 'string'
      # if we are just passed a string, make it into a proper job object
      job = text: job
    job.text ?= ''

    @sourceMap =
      version: 3
      sourcesContent: [job.text]
      names: []

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
        # merge the source maps
        if sourceMap.sourcesContent
          @sourceMap.sourcesContent = sourceMap.sourcesContent

        if not @sourceMap.mappings
          @sourceMap.mappings = sourceMap.mappings
        else
          sourceMap.sources = ['index'] #tmp
          sourceMap.file = 'index' #tmp
          @sourceMap.file = 'index' #tmp
          @sourceMap.sources = ['index'] #tmp
          newMap = JSON.parse(transferSourceMap(
            fromSourceMap: sourceMap
            toSourceMap: @sourceMap
          ))
          @sourceMap.mappings = newMap.mappings

        @sourceMap.file = sourceMap.file
        if sourceMap.sources
          @sourceMap.sources = sourceMap.sources
      else
        @sourceMap.sourcesContent = [text]
        delete @sourceMap.mappings

      # we can strip the trailing whitespace without changing the sourcemap
      @text = text.replace(/\s*$/, '\n')
    return this

  toString: => @text

  isJob: -> true

module.exports = Job
