Liquid = require "../../liquid"
Promise = require "bluebird"

module.exports = class Raw extends Liquid.Block
  parse: (tokens) ->
    Promise.try =>
      return Promise.cast() if tokens.length is 0 or @ended

      token = tokens.shift()
      match = Liquid.Block.FullToken.exec token.value

      return @endTag() if match?[1] is @blockDelimiter()

      @nodelist.push token.value
      @parse tokens
