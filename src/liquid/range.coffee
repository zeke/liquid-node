module.exports = class Range
  constructor: (@start, @end, @step = 0) ->
    if @step is 0
      if @end < @start
        @step = -1
      else
        @step = 1

    Object.seal @

  some: (f) ->
    current = @start
    end = @end
    step = @step

    while current < end
      return unless f current
      current += step

    @

  forEach: (f) ->
    @some (e) ->
      f e
      true

  toArray: ->
    array = []
    @forEach (e) ->
      array.push e
    array

Object.defineProperty Range::, "length",
  get: ->
    Math.floor((@end - @start) / @step)
