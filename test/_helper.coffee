Liquid = require("../src/index")
Promise = require "bluebird"

# JSON.stringify fails for circular dependencies
stringify = (v) ->
  try
    JSON.stringify(v, null, 2)
  catch e
    "Couldn't stringify: #{v}"

global.renderTest = (f) ->
  map = {}
  cnt = 0
  uniqueId = 0

  assertTemplateResult = (assert) ->
    (expected, template, assigns, message) ->
      engine = new Liquid.Engine
      actual = engine.parse(template).render(assigns)

      myId = uniqueId++
      cnt += 1
      map[myId] = { expected, template, assigns }

      actual.then (actual) ->
          assert.type actual, "string"
          assert.eql actual, expected, stringify({
            template,
            expected,
            actual,
            assigns
          })
        , (err) ->
          console.log "Unexpected error: %s, %s", err, err.stack
          assert.eql err, null
      .finally ->
        cnt -= 1
        delete map[myId]

  (exit, assert) ->
    f(assertTemplateResult(assert), assert)
    exit ->
      if cnt != 0
        for k, v of map
          console.log {
            template: v.template,
            expected: v.expected,
            rendered: null,
            assigns: Object.keys(v.assigns ? {})
          }

      assert.eql(0, cnt, "Not all render-tasks have finished: #{cnt} left.")

module.exports =
  testsTruth: (e, assert) ->
    assert.eql(true, true)

  testsRender: renderTest (render, assert) ->
    true
