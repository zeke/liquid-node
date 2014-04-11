Liquid = require("../src/index")
{ expect } = require "chai"

describe "Variables", ->
  it "test_variable", ->
    variable = new Liquid.Variable('hello')
    expect(variable.name).to.equal 'hello'

  it "test_filters", ->
    v = new Liquid.Variable('hello | textileze')
    expect('hello').to.equal v.name
    expect([["textileze",[]]]).to.deep.equal v.filters

    v = new Liquid.Variable('hello | textileze | paragraph')
    expect('hello').to.equal v.name
    expect([["textileze",[]], ["paragraph",[]]]).to.deep.equal v.filters

    v = new Liquid.Variable("""hello | strftime: '%Y'""")
    expect('hello').to.equal v.name
    expect([["strftime",["'%Y'"]]]).to.deep.equal v.filters

    v = new Liquid.Variable("""'typo' | link_to: 'Typo', true""")
    expect("""'typo'""").to.equal v.name
    expect([["link_to",["'Typo'", "true"]]]).to.deep.equal v.filters

    v = new Liquid.Variable("""'typo' | link_to: 'Typo', false""")
    expect("""'typo'""").to.equal v.name
    expect([["link_to",["'Typo'", "false"]]]).to.deep.equal v.filters

    v = new Liquid.Variable("""'foo' | repeat: 3""")
    expect("""'foo'""").to.equal v.name
    expect([["repeat",["3"]]]).to.deep.equal v.filters

    v = new Liquid.Variable("""'foo' | repeat: 3, 3""")
    expect("""'foo'""").to.equal v.name
    expect([["repeat",["3","3"]]]).to.deep.equal v.filters

    v = new Liquid.Variable("""'foo' | repeat: 3, 3, 3""")
    expect("""'foo'""").to.equal v.name
    expect([["repeat",["3","3","3"]]]).to.deep.equal v.filters

    v = new Liquid.Variable("""hello | strftime: '%Y, okay?'""")
    expect('hello').to.equal v.name
    expect([["strftime",["'%Y, okay?'"]]]).to.deep.equal v.filters

    v = new Liquid.Variable(""" hello | things: "%Y, okay?", 'the other one'""")
    expect('hello').to.equal v.name
    expect([["things",["\"%Y, okay?\"","'the other one'"]]]).to.deep.equal v.filters

  it "test_filter_with_date_parameter", ->
    v = new Liquid.Variable(""" '2006-06-06' | date: "%m/%d/%Y" """)
    expect("'2006-06-06'").to.equal v.name
    expect([["date",["\"%m/%d/%Y\""]]]).to.deep.equal v.filters

  # TODO

  it "test_simple_variable", ->
    renderTest('worked', '{{test}}', test:'worked')
    renderTest('worked wonderfully', '{{test}}', test:'worked wonderfully')

  it "test_local_filter", ->
    MoneyFilter =
      money: (input) ->
        require('util').format(' %d$ ', input)

      money_with_underscore: (input) ->
        require('util').format(' %d$ ', input)

    context = new Liquid.Context()
    context.set 'var', 1000
    context.addFilters(MoneyFilter)

    new Liquid.Variable("var | money").render(context).then (result) ->
      expect(result).to.equal ' 1000$ '