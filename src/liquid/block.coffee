Liquid = require("../liquid")
util = require "util"
Promise = require "bluebird"

module.exports = class Block extends Liquid.Tag
  @IsTag             = ///^#{Liquid.TagStart.source}///
  @IsVariable        = ///^#{Liquid.VariableStart.source}///
  @FullToken         = ///^#{Liquid.TagStart.source}\s*(\w+)\s*(.*)?#{Liquid.TagEnd.source}$///
  @ContentOfVariable = ///^#{Liquid.VariableStart.source}(.*)#{Liquid.VariableEnd.source}$///

  parse: (tokens) ->
    @nodelist or= []
    @nodelist.pop() while @nodelist.length > 0

    while tokens.length > 0
      token = tokens.shift()

      if Block.IsTag.test(token)
        if match = Block.FullToken.exec(token)
          # if we found the proper block delimitor just end parsing
          # here and let the outer block proceed

          if @blockDelimiter() == match[1]
            @endTag()
            return

          # fetch the tag from registered blocks
          if tag = @template.tags[match[1]]
            @nodelist.push new tag(@template, match[1], match[2], tokens)
          else
            # this tag is not registered with the system
            # pass it to the current block for special
            # handling or error reporting
            @unknownTag(match[1], match[2], tokens)
        else
          throw new Liquid.SyntaxError("Tag '#{token}' was not properly terminated with regexp: #{Liquid.TagEnd.inspect}")
      else if Block.IsVariable.test(token)
        @nodelist.push @createVariable(token)
      else if token == ''
        # pass
      else
        @nodelist.push token

    # Make sure that its ok to end parsing in the current block.
    # Effectively this method will throw and exception unless the
    # current block is of type Document
    @assertMissingDelimitation()

  endTag: ->

  unknownTag: (tag, params, tokens) ->
    switch tag
      when 'else'
        throw new Liquid.SyntaxError("#{@blockName()} tag does not expect else tag")
      when 'end'
        throw new Liquid.SyntaxError("'end' is not a valid delimiter for #{@blockName()} tags. use #{@blockDelimiter()}")
      else
        throw new Liquid.SyntaxError("Unknown tag '#{tag}'")

  blockDelimiter: ->
    "end#{@blockName()}"

  blockName: ->
    @tagName

  createVariable: (token) ->
    match = Liquid.Block.ContentOfVariable.exec(token)?[1]
    return new Liquid.Variable(match) if match
    throw new Liquid.SyntaxError("Variable '#{@token}' was not properly terminated with regexp: #{Liquid.Block.VariableEnd.inspect}")

  render: (context) ->
    @renderAll(@nodelist, context)

  assertMissingDelimitation: ->
    throw new Liquid.SyntaxError("#{@blockName()} tag was never closed")

  renderAll: (list, context) ->
    Promise.reduce(list, (output, token) ->
      if typeof token?.render is "function"
        Promise.try ->
          Promise
          .cast(token.render(context))
          .then (renderedToken) ->
            output.push renderedToken
            output
        .catch (e) ->
          output.push context.handleError e
          output
      else
        output.push token
        output
    , [])
    .then (all) -> all.join ""
