express = require 'express'
path    = require 'path'
fs      = require 'fs'
utils   = require './utils'
config  = require 'config'

Sequelize  = require 'sequelize'

requireDirectory = (directory) ->
  files = fs.readdirSync directory
  files = files.filter (name) ->
    '.coffee' is path.extname name
  files = files.map    (name) ->
    instance = require path.join directory, name
    instance.moduleName    = path.basename name.toLowerCase(), path.extname name
    instance.routerName    = utils.inflection.toRouter instance.moduleName
    instance.idName        = utils.inflection.toId instance.moduleName
    instance.modelName     = utils.inflection.toModel instance.moduleName
    instance.instanceName  = utils.inflection.toInstance instance.moduleName
    instance

Suki = (option = {}) ->
  app = express()

  unless option.skipUse
    app.use express.json()
    app.use express.urlencoded()
    app.use express.methodOverride()

  appDirectory =
    option.appDirectory or path.dirname module.parent.parent.filename

  # Load controllers
  controllers =
    requireDirectory path.join appDirectory, 'app', 'controllers'

  for controller in controllers
    controller._mapToRoute app, option

  if config.sequelize
    # Connect to Database via sequelize
    sequelize = new Sequelize config.sequelize.database,
      config.sequelize.username,
      config.sequelize.password,
      config.sequelize

  # Load models
  models =
    requireDirectory(path.join appDirectory, 'app', 'models')

  for model in models
    if model._type is 'Sequelize'
      throw new Error 'Missing config for sequelize' unless sequelize
      model._initModel Sequelize, sequelize

    global[model.modelName] = model.model

  # Init associations for Sequelize
  for model in models then model._initAssociations?()

  # Sync Database
  if config.sequelize?.sync
    sequelize.sync()

  app

Suki.Controller = require './Controller'
Suki.SequelizeModel = require './SequelizeModel'

global.Suki = module.exports = Suki
