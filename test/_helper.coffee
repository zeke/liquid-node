global.Liquid = Liquid = require("../#{if process.env.LIQUID_NODE_COVERAGE then "lib" else "src"}/index")

global.chai = chai = require "chai"
chai.use require "chai-as-promised"

global.expect = expect = chai.expect
Promise = require "bluebird"

# JSON.stringify fails for circular dependencies
stringify = (v) ->
  try
    JSON.stringify(v, null, 2)
  catch e
    "Couldn't stringify: #{v}"

global.renderTest = (expected, templateString, assigns) ->
  engine = new Liquid.Engine

  parser = engine.parse templateString

  renderer = parser.then (template) ->
    template.render assigns

  test = renderer.then (output) ->
    expect(output).to.be.a "string"
    expect(output).to.eq expected

  Promise.all([
    expect(parser).to.be.fulfilled
    expect(renderer).to.be.fulfilled
    test
  ])


