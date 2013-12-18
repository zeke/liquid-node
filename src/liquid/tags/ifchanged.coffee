Liquid = require "../../liquid"
Q = require "q"

module.exports = class IfChanged extends Liquid.Block
  render: (context) ->
    context.stack =>
      rendered = @renderAll @nodelist, context

      Q.when(rendered).then (output) ->
        if output isnt context.registers.ifchanged
          context.registers.ifchanged = output
        else
          ""
