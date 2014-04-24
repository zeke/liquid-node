describe "Liquid", ->
  beforeEach -> @engine = new Liquid.Engine

  context "parseAndRender", ->
    it "is supported", ->
      expect(@engine.parseAndRender("{{ foo }}", foo: 123)).to.be.fulfilled.then (output) ->
        expect(output).to.be.eq "123"

  context "parser", ->
    it "parses empty templates", ->
      expect(@engine.parse("")).to.be.fulfilled.then (template) ->
        expect(template.root).to.be.instanceOf Liquid.Document

    it "parses plain text", ->
      expect(@engine.parse("foo")).to.be.fulfilled.then (template) ->
        expect(template.root.nodelist).to.deep.equal ["foo"]

    it "parses variables", ->
      expect(@engine.parse("{{ foo }}")).to.be.fulfilled.then (template) ->
        expect(template.root.nodelist[0]).to.be.instanceOf Liquid.Variable

    it "parses blocks", ->
      expect(@engine.parse("{% for i in c %}{% endfor %}")).to.be.fulfilled.then (template) ->
        expect(template.root.nodelist[0]).to.be.instanceOf Liquid.Block

    it "parses complex documents", ->
      expect(@engine.parse("{% for i in c %}foo{% endfor %}{{ var }}")).to.be.fulfilled.then (template) ->
        expect(template.root.nodelist[0]).to.be.instanceOf Liquid.Block
        expect(template.root.nodelist[0].nodelist).to.deep.equal ["foo"]
        expect(template.root.nodelist[1]).to.be.instanceOf Liquid.Variable
        expect(template.root.nodelist[1].name).to.be.eq "var"

    it "parses for-blocks", ->
      expect(@engine.parse("{% for i in c %}{% endfor %}")).to.be.fulfilled.then (template) ->
        expect(template.root.nodelist[0]).to.be.instanceOf Liquid.For

    it "parses capture-blocks", ->
      expect(@engine.parse("{% capture foo %}foo{% endcapture %}")).to.be.fulfilled.then (template) ->
        expect(template.root.nodelist[0]).to.be.instanceOf Liquid.Capture
        expect(template.root.nodelist[0].nodelist).to.deep.equal ["foo"]

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
