Liquid = requireLiquid()

describe "Iterable", ->
  describe ".cast", ->
    it "doesn't cast iterables", ->
      iterable = new Liquid.Iterable()
      expect(Liquid.Iterable.cast(iterable)).to.equal iterable

    it "casts null/undefined to an empty iterable", ->
      expect(Liquid.Iterable.cast(null).toArray()).to.become []

  describe ".slice", ->
    it "is abstract", ->
      expect ->
        new Liquid.Iterable().slice()
      .to.throw /not implemented/

  describe ".last", ->
    it "is abstract", ->
      expect ->
        new Liquid.Iterable().last()
      .to.throw /not implemented/
