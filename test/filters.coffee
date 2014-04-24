describe "StandardFilters", ->
  beforeEach ->
    @filters = Liquid.StandardFilters

  for own filterName, filter of Liquid.StandardFilters
    describe filterName, ->
      [null, undefined, true, false, 1, "string", []].forEach (param) =>
        paramString = JSON.stringify param
        it "handles `#{paramString}` as input", ->
          expect ->
            filter(param)
          .not.to.throw()

  describe "size", ->
    it "returns 0 for ''", ->
      expect(@filters.size("")).to.be.eq 0

    it "returns 3 for 'abc'", ->
      expect(@filters.size("abc")).to.be.eq 3

    it "returns 0 for empty arrays", ->
      expect(@filters.size([])).to.be.eq 0

    it "returns 3 for [1,2,3]", ->
      expect(@filters.size([1,2,3])).to.be.eq 3

    it "returns 0 for numbers", ->
      expect(@filters.size(1)).to.be.eq 0

    it "returns 0 for true", ->
      expect(@filters.size(true)).to.be.eq 0

    it "returns 0 for false", ->
      expect(@filters.size(false)).to.be.eq 0

    it "returns 0 for null", ->
      expect(@filters.size(null)).to.be.eq 0

  describe "downcase", ->
    it "downcases strings", ->
      expect(@filters.downcase("HiThere")).to.be.eq "hithere"

    it "uses toString", ->
      o = toString: -> "aString"
      expect(@filters.downcase(o)).to.be.eq "astring"

  describe "upcase", ->
    it "upcases strings", ->
      expect(@filters.upcase("HiThere")).to.be.eq "HITHERE"

    it "uses toString", ->
      o = toString: -> "aString"
      expect(@filters.upcase(o)).to.be.eq "ASTRING"
