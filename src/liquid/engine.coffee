Liquid = require "../liquid"
{ _ } = require "underscore"
Promise = require "bluebird"

module.exports = class Liquid.Engine
  constructor: ->
    @tags = {}
    @registerFilter Liquid.StandardFilters
    
    isSubclassOf = (klass, ofKlass) ->
      unless typeof klass is 'function'
        false
      else if klass == ofKlass
        true
      else
        isSubclassOf klass.__super__?.constructor, ofKlass
    
    for own tagName, tag of Liquid
      continue unless isSubclassOf(tag, Liquid.Tag)
      isBlockOrTagBaseClass = [Liquid.Tag, Liquid.Block].indexOf(tag.constructor) >= 0
      @registerTag tagName.toLowerCase(), tag unless isBlockOrTagBaseClass

  registerTag: (name, tag) ->
    @tags[name] = tag

  registerFilter: (obj) ->
    Liquid.Strainer.globalFilter obj

  parse: (source) ->
    template = new Liquid.Template
    template.parse @, source
    template