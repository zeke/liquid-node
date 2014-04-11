Liquid = require "../../liquid"
Promise = require "bluebird"

module.exports = class IfChanged extends Liquid.Block
  render: (context) ->
    context.stack =>
      rendered = @renderAll @nodelist, context

      Promise.cast(rendered).then (output) ->
        if output isnt context.registers.ifchanged
          context.registers.ifchanged = output
        else
          ""
