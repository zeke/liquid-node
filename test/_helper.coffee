Liquid = require("../src/index")
{ expect } = require "chai"

# JSON.stringify fails for circular dependencies
stringify = (v) ->
  try
    JSON.stringify(v, null, 2)
  catch e
    "Couldn't stringify: #{v}"

global.renderTest = (expected, template, assigns) ->
  engine = new Liquid.Engine
  actual = engine.parse(template).render(assigns)

  actual
  .catch (e) ->
    expect(e).not.to.exist
  .then (actual) ->
    expect(actual).to.be.a "string"
    expect(actual).to.eq expected
