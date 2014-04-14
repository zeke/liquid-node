Liquid = require("../src/index")
{ expect } = require "chai"

describe "Liquid", ->
  beforeEach -> @engine = new Liquid.Engine

  it "reports parsing errors", ->
    expect =>
      @engine.parse("{% illegal %}")
    .to.throw Liquid.SyntaxError, "Unknown tag 'illegal' at line 1 column 1"

  it "reports parsing errors", ->
    expect =>
      @engine.parse(" {% illegal %}")
    .to.throw Liquid.SyntaxError, "Unknown tag 'illegal' at line 1 column 2"

  it "reports parsing errors", ->
    expect =>
      @engine.parse("{{ okay }}\n\n   {% illegal %}")
    .to.throw Liquid.SyntaxError, "Unknown tag 'illegal' at line 3 column 4"
