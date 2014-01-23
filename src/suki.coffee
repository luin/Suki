express = require 'express'
path    = require 'path'
fs      = require 'fs'

Sequelize  = require 'sequelize'

utils   = require './utils'

config  = require 'config'


requireDirectory = (directory) ->
  files = fs.readdirSync directory
  files = files.filter (name) ->
    '.coffee' is path.extname name
  files = files.map    (name) ->
    instance = require path.join directory, name
    instance.moduleName = path.basename name.toLowerCase(), path.extname name
    instance

Suki = (option = {}) ->
  global.Suki = Suki
  app = express()
  app.use express.bodyParser()
  app.use express.methodOverride()
  appDirectory =
    option.appDirectory or path.dirname module.parent.parent.filename

  sequelize = new Sequelize config.sequelize.database,
    config.sequelize.username,
    config.sequelize.password,
    config.sequelize

  modelList = requireDirectory(path.join appDirectory, 'app', 'models')

  models = {}
  for model in modelList
    model.modelName = utils.inflection.toModel model.moduleName
    model.model = sequelize.define model.modelName,
      model.define(Sequelize),
      model.config
    models[model.modelName] = model.model

  app.set 'models', models

  sequelize.sync()

  controllers =
    requireDirectory path.join appDirectory, 'app', 'controllers'

  app.set 'controllers', controllers
  for controller in controllers
    controller._mapToRoute app

  app


Suki.Controller = require './Controller'
Suki.Model = require './Model'

module.exports = Suki

