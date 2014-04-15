Liquid = require("../liquid")
util = require "util"
Promise = require "bluebird"

module.exports = class Block extends Liquid.Tag
  @IsTag             = ///^#{Liquid.TagStart.source}///
  @IsVariable        = ///^#{Liquid.VariableStart.source}///
  @FullToken         = ///^#{Liquid.TagStart.source}\s*(\w+)\s*(.*)?#{Liquid.TagEnd.source}$///
  @ContentOfVariable = ///^#{Liquid.VariableStart.source}(.*)#{Liquid.VariableEnd.source}$///

  parse: (tokens) ->
    @nodelist ?= []
    @nodelist.length = 0 # clear array

    @_parse(tokens).then =>
      # Make sure that its ok to end parsing in the current block.
      # Effectively this method will throw and exception unless the
      # current block is of type Document
      @assertMissingDelimitation()

  _parse: (tokens) ->
    return Promise.cast() if tokens.length is 0 or @ended
    token = tokens.shift()

    @_promise = Promise
    .try =>
      if Block.IsTag.test(token.value)
        match = Block.FullToken.exec(token.value)

        unless match
          throw new Liquid.SyntaxError("Tag '#{token.value}' was not properly terminated with regexp: #{Liquid.TagEnd.inspect}")

        return @endTag() if @blockDelimiter() is match[1]

        Tag = @template.tags[match[1]]
        return @unknownTag match[1], match[2], tokens unless Tag

        tag = new Tag @template, match[1], match[2], tokens
        @nodelist.push tag
        tag._promise
      else if Block.IsVariable.test(token.value)
        @nodelist.push @createVariable(token)
      else if token.value.length is 0
        # skip empty tokens
      else
        @nodelist.push token.value
    .catch (e) =>
      e.message = "#{e.message}\n    at #{token.value} (#{token.filename}:#{token.line}:#{token.col})"
      e.location ?= { col: token.col, line: token.line, filename: token.filename }
      throw e
    .then =>
      @_parse tokens

  endTag: ->
    @ended = true

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
    match = Liquid.Block.ContentOfVariable.exec(token.value)?[1]
    return new Liquid.Variable(match) if match
    throw new Liquid.SyntaxError("Variable '#{token.value}' was not properly terminated with regexp: #{Liquid.Block.VariableEnd.inspect}")

  render: (context) ->
    @renderAll @nodelist, context

  assertMissingDelimitation: ->
    throw new Liquid.SyntaxError("#{@blockName()} tag was never closed") unless @ended

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
