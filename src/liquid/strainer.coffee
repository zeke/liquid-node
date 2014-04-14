module.exports = class Strainer

  constructor: (@context) ->
    
  extend: (filter) ->
    for own k, v of filter
      @[k] = v
      
  @globalFilter: (filter) ->
    @::extend.call Strainer::, filter

  @create: (context) ->
    new Strainer context
