describe "Range", ->
  it "can be converted to array", ->
    expect(new Liquid.Range(0, 1).toArray()).to.deep.equal [0]
    expect(new Liquid.Range(0, 2).toArray()).to.deep.equal [0, 1]
    expect(new Liquid.Range(1, 2).toArray()).to.deep.equal [1]

  it "has a length", ->
    expect(new Liquid.Range(0, 1).length).to.equal 1
    expect(new Liquid.Range(0, 2).length).to.equal 2
    expect(new Liquid.Range(1, 2).length).to.equal 1
