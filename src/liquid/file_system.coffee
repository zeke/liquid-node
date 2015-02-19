Liquid = require "../liquid"
Promise = require "bluebird"
Fs = Promise.promisifyAll require "fs"
Path = require "path"

module.exports = class Liquid.LocalFileSystem

  PathPattern = ///^[^.\/][a-zA-Z0-9-_\/]+$///

  constructor: (root, extension = "html") ->
    @root = root
    @fileExtension = extension

  readTemplateFile: (templatePath, context) ->

    @fullPath(templatePath)
      .then (fullPath) ->
        Fs.readFileAsync(fullPath, 'utf8')
          .catch (err) ->
            throw new Liquid.FileSystemError "Error loading template: #{err.message}"


  fullPath: (templatePath) ->
    new Promise (resolve, reject) =>
      reject new Liquid.ArgumentError "Illegal template name '#{templatePath}'" unless PathPattern.test templatePath
      resolve Path.resolve(Path.join(@root, Path.dirname(templatePath), Path.basename(templatePath + ".#{@fileExtension}")))
