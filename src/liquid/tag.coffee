Promise = require "bluebird"

module.exports = class Tag
  constructor: (@template, @tagName, @markup) ->

  parseWithCallbacks: (args...) ->
    if @afterParse
      parse = => @parse(args...).then => @afterParse(args...)
    else
      parse = => @parse(args...)
      
    if @beforeParse
      Promise.cast(@beforeParse(args...)).then parse
    else
      parse()

  parse: ->

  name: ->
    # /^function (\w+)\(/.exec(@constructor.toString())?[1]
    (@constructor.name ? 'UnknownTag').toLowerCase()

  render: ->
    ""
