describe "Liquid", ->
  beforeEach -> @engine = new Liquid.Engine

  context "reports error locations", ->
    it "at beginning of file", ->
      expect(@engine.parse("{% illegal %}")).to.be.rejectedWith Liquid.SyntaxError,
        "Unknown tag 'illegal'\n    at {% illegal %} (undefined:1:1)"

    it "at the beginning of a line", ->
      expect(@engine.parse(" {% illegal %}")).to.be.rejectedWith Liquid.SyntaxError,
        "Unknown tag 'illegal'\n    at {% illegal %} (undefined:1:2)"

    it "in the middle of a line", ->
      expect(@engine.parse("{{ okay }}\n\n   {% illegal %}")).to.be.rejectedWith Liquid.SyntaxError,
        "Unknown tag 'illegal'\n    at {% illegal %} (undefined:3:4)"
