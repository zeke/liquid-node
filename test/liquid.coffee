describe "Liquid", ->
  beforeEach -> @engine = new Liquid.Engine

  context "reports error locations", ->
    it "at beginning of file", ->
      @engine.parse("{% illegal %}").catch (e) ->
        expect(e).to.be.an.instanceOf Liquid.SyntaxError
        expect(e.message).to.be.eq "Unknown tag 'illegal'\n    at {% illegal %} (undefined:1:1)"

    it "at the beginning of a line", ->
      @engine.parse(" {% illegal %}").catch (e) ->
        expect(e).to.be.an.instanceOf Liquid.SyntaxError
        expect(e.message).to.be.eq "Unknown tag 'illegal'\n    at {% illegal %} (undefined:1:2)"

    it "in the middle of a line", ->
      @engine.parse("{{ okay }}\n\n   {% illegal %}").catch (e) ->
        expect(e).to.be.an.instanceOf Liquid.SyntaxError
        expect(e.message).to.be.eq "Unknown tag 'illegal'\n    at {% illegal %} (undefined:3:4)"
