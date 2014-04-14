Liquid = require "../liquid"
{ _ } = require "underscore"
Promise = require "bluebird"

module.exports = class Liquid.Template

  # creates a new <tt>Template</tt> from an array of tokens.
  # Use <tt>Template.parse</tt> instead
  constructor: ->
    @registers = {}
    @assigns = {}
    @instanceAssigns = {}
    @tags = {}
    @errors = []
    @rethrowErrors = true

  # Parse source code.
  # Returns self for easy chaining
  parse: (@engine, source = "") ->
    @tags = @engine.tags
    @root = new Liquid.Document @, @tokenize(source)
    @

  # Render takes a hash with local variables.
  #
  # if you use the same filters over and over again consider
  # registering them globally
  # with <tt>Template.register_filter</tt>
  #
  # Following options can be passed:
  #
  #  * <tt>filters</tt> : array with local filters
  #  * <tt>registers</tt> : hash with register variables. Those can
  #    be accessed from filters and tags and might be useful to integrate
  #    liquid more with its host application
  #
  _render: (args...) ->
    return Promise.cast("") unless @root?

    context = if args[0] instanceof Liquid.Context
      args.shift()
    else if args[0] instanceof Object
      new Liquid.Context([args.shift(), @assigns], @instanceAssigns, @registers, @rethrowErrors)
    else if not args[0]?
      new Liquid.Context(@assigns, @instanceAssigns, @registers, @rethrowErrors)
    else
      throw new Error("Expect Hash or Liquid::Context as parameter")

    last = args[args.length - 1]
    if last instanceof Object and (last.registers? or last.filters?)
      options = args.pop()

      if options.registers
        _.merge(@registers, options.registers)

      if options.filters
        context.addFilters(options.filters)
    else if last instanceof Object
      context.addFilters(args.pop())

    try
      # render the nodelist.
      # TODO: original implementation used arrays up until here (for performance reasons)
      Promise.cast(@root.render(context))
    finally
      @errors = context.errors

  render: (args...) ->
    Promise.try => @_render args...

  # private api

  # Uses the <tt>Liquid::TemplateParser</tt> regexp to tokenize
  # the passed source
  tokenize: (source) ->
    source = source.source if source.source?
    return [] if source.toString().length == 0
    tokens = source.split(Liquid.TemplateParser)

    # removes the rogue empty element at the beginning of the array
    tokens.shift() if tokens[0] and tokens[0].length == 0

    tokens
