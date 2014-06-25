Liquid = require("../liquid")
Promise = require "bluebird"

# Holds variables. Variables are only loaded "just in time"
# and are not evaluated as part of the render stage
#
#   {{ monkey }}
#   {{ user.name }}
#
# Variables can be combined with filters:
#
#   {{ user | link }}
#
module.exports = class Variable
  @FilterParser = ///(?:#{Liquid.FilterSeparator.source}|(?:\s*(?!(?:#{Liquid.FilterSeparator.source}))(?:#{Liquid.QuotedFragment.source}|\S+)\s*)+)///
  VariableNameFragment = ///\s*(#{Liquid.QuotedFragment.source})(.*)///
  FilterListFragment = ///#{Liquid.FilterSeparator.source}\s*(.*)///
  FilterArgParser = ///(?:#{Liquid.FilterArgumentSeparator.source}|#{Liquid.ArgumentSeparator.source})\s*(#{Liquid.QuotedFragment.source})///

  constructor: (@markup) ->
    @name = null
    @filters = []

    match = VariableNameFragment.exec @markup
    return unless match

    @name = match[1]

    match = FilterListFragment.exec match[2]
    return unless match

    filters = Liquid.Helpers.scan match[1], Liquid.Variable.FilterParser
    filters.forEach (filter) =>
      match = /\s*(\w+)/.exec filter
      return unless match
      filterName = match[1]
      filterArgs = Liquid.Helpers.scan filter, FilterArgParser
      filterArgs = Liquid.Helpers.flatten filterArgs
      @filters.push [filterName, filterArgs]

  render: (context) ->
    return '' unless @name?

    reducer = (output, filter) =>
      filterArgs = filter[1].map (a) -> context.get a

      Promise
      .join(output, filterArgs...)
      .spread (output, filterArgs...) =>
        try
          context.invoke filter[0], output, filterArgs...
        catch e
          throw e unless e instanceof Liquid.FilterNotFound
          throw new Liquid.FilterNotFound("Error - filter '#{filter[0]}' in '#{@markup}' could not be found.")

    Promise
    .cast(context.get(@name))
    .then (value) =>
      Promise
      .reduce(@filters, reducer, value)
      .then (value) ->
        if value instanceof Liquid.Drop
          value.context = context
          value.toString()
        else
          value
      , (e) ->
        context.handleError e
