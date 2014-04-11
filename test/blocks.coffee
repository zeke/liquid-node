Liquid = require("../src/index")
Promise = require "bluebird"
{ expect } = require "chai"

describe "Blocks", ->
  it "test_assigned_variable", ->
    Promise.all([
      renderTest  '.foo.',
              '{% assign foo = values %}.{{ foo[0] }}.',
              'values': ["foo", "bar", "baz"]

      renderTest  '.bar.',
              '{% assign foo = values %}.{{ foo[1] }}.',
              'values': ["foo", "bar", "baz"]
    ])

  it "test_for_with_variable", ->
    Promise.all([
      renderTest(' 1  2  3 ', '{%for item in array%} {{item}} {%endfor%}', array: [1, 2, 3])
      renderTest('123', '{%for item in array%}{{item}}{%endfor%}', array: [1, 2, 3])
      renderTest('123', '{% for item in array %}{{item}}{% endfor %}', array: [1, 2, 3])
      renderTest('abcd', '{%for item in array%}{{item}}{%endfor%}', array: ['a', 'b', 'c', 'd'])
      renderTest('a b c', '{%for item in array%}{{item}}{%endfor%}', array: ['a', ' ', 'b', ' ', 'c'])
      renderTest('abc', '{%for item in array%}{{item}}{%endfor%}', array: ['a', '', 'b', '', 'c'])
    ])
      
  it "test_for_index", ->
    Promise.all([
      renderTest('123', '{%for item in array%}{{forloop.index}}{%endfor%}', array: [1,2,3])
      renderTest('321', '{%for item in array%}{{forloop.rindex}}{%endfor%}', array: [1,2,3])
      renderTest('210', '{%for item in array%}{{forloop.rindex0}}{%endfor%}', array: [1,2,3])
      renderTest('123', '{%for item in array%}{{forloop.index}}{%endfor%}', array: ['a','b','c'])
      renderTest('123', '{%for item in array%}{{forloop.index}}{%endfor%}', array: ['a','b','c'])
      renderTest('012', '{%for item in array%}{{forloop.index0}}{%endfor%}', array: ['a','b','c'])
      renderTest('1234', '{%for item in array%}{{forloop.index}}{%endfor%}', array: [{a:1},{b:1},{c:1},{d:1}])
      renderTest('', '{%for item in array%}{{forloop.index}}{%endfor%}', array: [])
      renderTest('first123', '{% for item in array %}{% if forloop.first%}first{% endif %}{{forloop.index}}{% endfor %}', array: [1,2,3])
      renderTest('123last', '{% for item in array %}{{forloop.index}}{% if forloop.last%}last{% endif %}{% endfor %}', array: [1,2,3])
      renderTest('vw', '{%for item in array limit:2%}{{item}}{%endfor%}', array: ['v','w','x','y'])
      renderTest('xy', '{%for item in array offset:2%}{{item}}{%endfor%}', array: ['v','w','x','y'])
    ])

  it "test_ifchanged", ->
    Promise.all([
      renderTest('123', '{%for item in array%}{%ifchanged%}{{item}}{% endifchanged %}{%endfor%}', array: [ 1, 1, 2, 2, 3, 3 ])
      renderTest('1', '{%for item in array%}{%ifchanged%}{{item}}{% endifchanged %}{%endfor%}', array: [ 1, 1, 1, 1 ])
    ])

  it "test_reverse", ->
    array = [ 1, 2, 3 ]
    renderTest('321', '{% for item in array reversed %}{{ item }}{% endfor %}', array: array).then ->
      # assert array unmodified
      expect(array.length).to.eql 3
      expect(array[0]).to.eql 1

