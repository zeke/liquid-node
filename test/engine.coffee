Liquid = requireLiquid()

describe "Engine", ->
  beforeEach ->
    @filters = Liquid.StandardFilters

  it "should create strainers", ->
    engine = new Liquid.Engine
    strainer = new engine.Strainer()
    expect(strainer.size).to.exist

  it "should create separate strainers", ->
    engine1 = new Liquid.Engine
    engine1.registerFilters foo1: -> "foo1"
    strainer1 = new engine1.Strainer()
    expect(strainer1.size).to.exist
    expect(strainer1.foo1).to.exist

    engine2 = new Liquid.Engine
    engine2.registerFilters foo2: -> "foo2"
    strainer2 = new engine2.Strainer()
    expect(strainer2.size).to.exist
    expect(strainer2.foo2).to.exist

    expect(strainer1.foo2).not.to.exist
    expect(strainer2.foo1).not.to.exist
