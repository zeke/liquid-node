describe "StandardFilters", ->
  beforeEach ->
    @filters = Liquid.StandardFilters

  for own filterName, filter of Liquid.StandardFilters
    describe filterName, ->
      [null, undefined, true, false, 1, "string", [], {}].forEach (param) =>
        paramString = JSON.stringify param
        it "handles `#{paramString}` as input", ->
          expect ->
            filter(param)
          .not.to.throw()

  describe "size", ->
    it "returns 0 for ''", ->
      expect(@filters.size("")).to.equal 0

    it "returns 3 for 'abc'", ->
      expect(@filters.size("abc")).to.equal 3

    it "returns 0 for empty arrays", ->
      expect(@filters.size([])).to.equal 0

    it "returns 3 for [1,2,3]", ->
      expect(@filters.size([1,2,3])).to.equal 3

    it "returns 0 for numbers", ->
      expect(@filters.size(1)).to.equal 0

    it "returns 0 for true", ->
      expect(@filters.size(true)).to.equal 0

    it "returns 0 for false", ->
      expect(@filters.size(false)).to.equal 0

    it "returns 0 for null", ->
      expect(@filters.size(null)).to.equal 0

  describe "downcase", ->
    it "downcases strings", ->
      expect(@filters.downcase("HiThere")).to.equal "hithere"

    it "uses toString", ->
      o = toString: -> "aString"
      expect(@filters.downcase(o)).to.equal "astring"

  describe "upcase", ->
    it "upcases strings", ->
      expect(@filters.upcase("HiThere")).to.equal "HITHERE"

    it "uses toString", ->
      o = toString: -> "aString"
      expect(@filters.upcase(o)).to.equal "ASTRING"

  describe "append", ->
    it "appends strings", ->
      expect(@filters.append("Hi", "There")).to.equal "HiThere"

  describe "prepend", ->
    it "prepends strings", ->
      expect(@filters.prepend("There", "Hi")).to.equal "HiThere"

  describe "capitalize", ->
    it "capitalizes words in the input sentence", ->
      expect(@filters.capitalize("hi there.")).to.equal "Hi there."

  describe "sort", ->
    it "sorts elements in array", ->
      expect(@filters.sort([1, 3, 2])).to.deep.equal([1, 2, 3])

    it "sorts non-primitive elements in array via property", ->
      expect(@filters.sort([
        { name: "sirlantis" },
        { name: "shopify" },
        { name: "dotnil" }
      ], "name")).to.deep.equal([
        { name: "dotnil" },
        { name: "shopify" },
        { name: "sirlantis" }
      ])

  describe "map", -> 
    it "maps/collects an array on a given property", ->
      expect(@filters.map([1, 2, 3])).to.deep.equal([1, 2, 3])
      expect(@filters.map([
        { name: "sirlantis" },
        { name: "shopify" },
        { name: "dotnil" }
      ], "name")).to.deep.equal([ "sirlantis", "shopify", "dotnil" ])

  describe "escape", ->
    it "escapes strings", ->
      expect(@filters.escape("<strong>")).to.equal "&lt;strong&gt;" 

  describe "escape_once", ->
    it "returns an escaped version of html without affecting existing escaped entities", ->
      expect(@filters.escape_once("&lt;strong&gt;Hulk</strong>"))
        .to.equal "&lt;strong&gt;Hulk&lt;/strong&gt;"

  describe "strip_html", ->
    it "strip html from string", ->
      expect(@filters.strip_html("<div>test</div>")).to.equal "test"
      expect(@filters.strip_html("<div id='test'>test</div>")).to.equal "test"
      
      expect(@filters.strip_html(
        "<script type='text/javascript'>document.write('some stuff');</script>"
      )).to.equal ""
      
      expect(@filters.strip_html(
        "<style type='text/css'>foo bar</style>"
      )).to.equal ""

      expect(@filters.strip_html(
        "<div\nclass='multiline'>test</div>"
      )).to.equal "test"

  describe "strip_newlines", ->
    it "strip all newlines (\n) from string", ->
      expect(@filters.strip_newlines("a\nb\nc")).to.equal "abc"
      expect(@filters.strip_newlines("a\r\nb\nc")).to.equal "abc"

  describe "newline_to_br", ->
    it "replace each newline (\n) with html break", ->
      expect(@filters.newline_to_br("a\nb\nc")).to.equal "a<br />\nb<br />\nc"

  describe "replace", ->
    it "replace each occurrence", ->
      expect(@filters.replace("1 1 1 1", "1", "2")).to.equal "2 2 2 2"

  describe "replace_first", ->
    it "replace the first occurrence", ->
      expect(@filters.replace_first("1 1 1 1", "1", "2")).to.equal "2 1 1 1"

  describe "remove", ->
    it "remove each occurrence", ->
      expect(@filters.remove("a a a a", "a")).to.equal "   "

  describe "remove_first", ->
    it "remove the first occurrence", ->
      expect(@filters.remove_first("a a a a", "a")).to.equal " a a a"
