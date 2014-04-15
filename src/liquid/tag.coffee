module.exports = class Tag
  constructor: (@template, @tagName, @markup, tokens) ->
    @_promise = @parse tokens

  parse: ->

  name: ->
    # /^function (\w+)\(/.exec(@constructor.toString())?[1]
    (@constructor.name ? 'UnknownTag').toLowerCase()

  render: ->
    ""
