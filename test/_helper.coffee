Liquid = require("../src/index")
Promise = require "bluebird"
{ expect } = require "chai"

# JSON.stringify fails for circular dependencies
stringify = (v) ->
  try
    JSON.stringify(v, null, 2)
  catch e
    "Couldn't stringify: #{v}"

global.renderTest = (expected, template, assigns, message) ->
  engine = new Liquid.Engine
  actual = engine.parse(template).render(assigns)

  actual
  .then (actual) ->
    expect(actual).to.be.a "string"
    expect(actual).to.eq expected
