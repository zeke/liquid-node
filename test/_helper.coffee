Liquid = require("../src/index")
{ expect } = require "chai"

# JSON.stringify fails for circular dependencies
stringify = (v) ->
  try
    JSON.stringify(v, null, 2)
  catch e
    "Couldn't stringify: #{v}"

global.renderTest = (expected, templateString, assigns) ->
  engine = new Liquid.Engine
  
  parser = engine.parse templateString
  parser.catch (e) -> expect(e).not.to.exist
  
  renderer = parser.then (template) -> template.render assigns
  renderer.catch (e) -> expect(e).not.to.exist
  renderer.then (output) ->
    expect(output).to.be.a "string"
    expect(output).to.eq expected
