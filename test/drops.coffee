Liquid = requireLiquid()

describe "Drop", ->
  beforeEach ->
    class @Droplet extends Liquid.Drop
      a: 1
      b: -> 2

    @drop = new @Droplet

  it "is an instanceof Drop", ->
    expect(@drop).to.be.instanceof @Droplet
    expect(@drop).to.be.instanceof Liquid.Drop

  it "protects regular objects", ->
    notDrop = { a: 1, b: -> "foo" }
    renderTest "1", "{{ drop.a }}{{ drop.b }}", { drop: notDrop }

  it "can be rendered", ->
    renderTest "12", "{{ drop.a }}{{ drop.b }}", { @drop }

  it "checks if methods are invokable", ->
    expect(@Droplet.isInvokable("a")).to.be.ok
    expect(@Droplet.isInvokable("b")).to.be.ok
    expect(@Droplet.isInvokable("toLiquid")).to.be.ok

    expect(@Droplet.isInvokable("c")).to.be.not.ok
    expect(@Droplet.isInvokable("invokeDrop")).to.be.not.ok
    expect(@Droplet.isInvokable("beforeMethod")).to.be.not.ok
    expect(@Droplet.isInvokable("hasKey")).to.be.not.ok

  it "renders", ->
    renderTest "[Liquid.Drop Droplet]", "{{ drop }}", { @drop }

  it "allows method-hooks", ->
    @drop.beforeMethod = (m) ->
      if m is "c"
        1
      else
        2

    renderTest "12", "{{ drop.c }}{{ drop.d }}", { @drop }
