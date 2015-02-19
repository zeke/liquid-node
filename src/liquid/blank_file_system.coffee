Liquid = require "../liquid"
Promise = require "bluebird"

module.exports = class Liquid.BlankFileSystem
  constructor: () ->

  readTemplateFile: (templatePath) ->
    new Promise (resolve, reject) ->
      reject new Liquid.FileSystemError "This file system doesn't allow includes"
