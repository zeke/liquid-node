Liquid = require "../../liquid"

module.exports = class Raw extends Liquid.Block
  parse: (tokens) ->
    Promise.try =>
      return Promise.cast() if tokens.length is 0 or @ended

      token = tokens.shift()
      match = Liquid.Block.FullToken.exec(token)

      if match and @blockDelimiter() is match[1]
        return @endTag()
      else if token.length > 0
        @nodelist.push token

    .then =>
      @parse tokens
