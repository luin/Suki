Mocha = require "mocha"
fs    = require "fs"
path  = require "path"
should = require 'should'

mocha = new Mocha

dir = "./test"
isCoffee = (file) -> /\.((lit)?coffee|coffee\.md)$/.test(file)

fs.readdirSync(dir)
  .filter (file)->
    isCoffee(file)
  .forEach (file)-> mocha.addFile(path.join(dir, file))

mocha
  .run (failures)->
    process.exit(failures)

