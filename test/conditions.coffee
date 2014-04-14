Liquid = require("../src/index")
Promise = require "bluebird"

describe "Conditions", ->
  it "test_if", ->
    Promise.all([
      renderTest('  ',' {% if false %} this text should not go into the output {% endif %} ')
      renderTest('  this text should go into the output  ',
                             ' {% if true %} this text should go into the output {% endif %} ')
      renderTest('  you rock ?','{% if false %} you suck {% endif %} {% if true %} you rock {% endif %}?')
    ])


  it "test_if_else", ->
    Promise.all([
      renderTest(' YES ','{% if false %} NO {% else %} YES {% endif %}')
      renderTest(' YES ','{% if true %} YES {% else %} NO {% endif %}')
      renderTest(' YES ','{% if "foo" %} YES {% else %} NO {% endif %}')
    ])

  it "test_if_boolean", ->
    Promise.all([
      renderTest(' YES ','{% if var %} YES {% endif %}', 'var': true)
    ])

  it "test_if_or", ->
    Promise.all([
      renderTest(' YES ','{% if a or b %} YES {% endif %}', 'a': true, 'b': true)
      renderTest(' YES ','{% if a or b %} YES {% endif %}', 'a': true, 'b': false)
      renderTest(' YES ','{% if a or b %} YES {% endif %}', 'a': false, 'b': true)
      renderTest('',     '{% if a or b %} YES {% endif %}', 'a': false, 'b': false)

      renderTest(' YES ','{% if a or b or c %} YES {% endif %}', 'a': false, 'b': false, 'c': true)
      renderTest('',     '{% if a or b or c %} YES {% endif %}', 'a': false, 'b': false, 'c': false)
    ])

  it "test_if_or_with_operators", ->
    Promise.all([
      renderTest(' YES ','{% if a == true or b == true %} YES {% endif %}', 'a': true, 'b': true)
      renderTest(' YES ','{% if a == true or b == false %} YES {% endif %}', 'a': true, 'b': true)
      renderTest('','{% if a == false or b == false %} YES {% endif %}', 'a': true, 'b': true)
    ])

  it "test_comparison_of_strings_containing_and_or_or", ->
    awful_markup = "a == 'and' and b == 'or' and c == 'foo and bar' and d == 'bar or baz' and e == 'foo' and foo and bar"
    assigns = {'a': 'and', 'b': 'or', 'c': 'foo and bar', 'd': 'bar or baz', 'e': 'foo', 'foo': true, 'bar': true}
    renderTest(' YES ',"{% if #{awful_markup} %} YES {% endif %}", assigns)

  it "test_if_from_variable", ->
    Promise.all([
      renderTest('','{% if var %} NO {% endif %}', 'var': false)
      renderTest('','{% if var %} NO {% endif %}', 'var': null)
      renderTest('','{% if foo.bar %} NO {% endif %}', 'foo': {'bar': false})
      renderTest('','{% if foo.bar %} NO {% endif %}', 'foo': {})
      renderTest('','{% if foo.bar %} NO {% endif %}', 'foo': null)
      renderTest('','{% if foo.bar %} NO {% endif %}', 'foo': true)

      renderTest(' YES ','{% if var %} YES {% endif %}', 'var': "text")
      renderTest(' YES ','{% if var %} YES {% endif %}', 'var': true)
      renderTest(' YES ','{% if var %} YES {% endif %}', 'var': 1)
      renderTest(' YES ','{% if var %} YES {% endif %}', 'var': {})
      renderTest(' YES ','{% if var %} YES {% endif %}', 'var': [])
      renderTest(' YES ','{% if "foo" %} YES {% endif %}')
      renderTest(' YES ','{% if foo.bar %} YES {% endif %}', 'foo': {'bar': true})
      renderTest(' YES ','{% if foo.bar %} YES {% endif %}', 'foo': {'bar': "text"})
      renderTest(' YES ','{% if foo.bar %} YES {% endif %}', 'foo': {'bar': 1 })
      renderTest(' YES ','{% if foo.bar %} YES {% endif %}', 'foo': {'bar': {} })
      renderTest(' YES ','{% if foo.bar %} YES {% endif %}', 'foo': {'bar': [] })

      renderTest(' YES ','{% if var %} NO {% else %} YES {% endif %}', 'var': false)
      renderTest(' YES ','{% if var %} NO {% else %} YES {% endif %}', 'var': null)
      renderTest(' YES ','{% if var %} YES {% else %} NO {% endif %}', 'var': true)
      renderTest(' YES ','{% if "foo" %} YES {% else %} NO {% endif %}', 'var': "text")

      renderTest(' YES ','{% if foo.bar %} NO {% else %} YES {% endif %}', 'foo': {'bar': false})
      renderTest(' YES ','{% if foo.bar %} YES {% else %} NO {% endif %}', 'foo': {'bar': true})
      renderTest(' YES ','{% if foo.bar %} YES {% else %} NO {% endif %}', 'foo': {'bar': "text"})
      renderTest(' YES ','{% if foo.bar %} NO {% else %} YES {% endif %}', 'foo': {'notbar': true})
      renderTest(' YES ','{% if foo.bar %} NO {% else %} YES {% endif %}', 'foo': {})
      renderTest(' YES ','{% if foo.bar %} NO {% else %} YES {% endif %}', 'notfoo': {'bar': true})
    ])

  describe "unless", ->
    it "negates 'false'", ->
      renderTest(' TRUE ','{% unless false %} TRUE {% endunless %}')

    it "negates 'true'", ->
      renderTest('','{% unless true %} FALSE {% endunless %}')
