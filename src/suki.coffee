express = require 'express'
path    = require 'path'
fs      = require 'fs'
utils   = require './utils'
config  = require 'config'

global.Sequelize  = require 'sequelize'

requireDirectory = (directory) ->
  files = fs.readdirSync directory
  files = files.filter (name) ->
    '.coffee' is path.extname name
  files = files.map    (name) ->
    instance = require path.join directory, name
    moduleName = path.basename name.toLowerCase(), path.extname name
    utils.storeNames instance, moduleName

Suki = (option = {}) ->
  app = express()

  unless option.skipUse
    app.use express.json()
    app.use express.urlencoded()
    app.use express.methodOverride()

  appDirectory =
    option.appDirectory or path.dirname module.parent.parent.filename

  app.set 'views', path.join appDirectory, 'app', 'views'
  app.set 'view engine', 'jade'


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
      model._initModel sequelize

    global[model.modelName] = model.model
    app.set "model#{model.modelName}", model.model

  # Init associations for Sequelize
  for model in models then model._initAssociations?()

  # Sync Database
  if config.sequelize?.sync
    sequelize.sync()

  # Load services
  services = {}
  requireDirectory(path.join appDirectory, 'app', 'services')
    .forEach (service) ->
      services[service.moduleName] = service

  app.set 'suki.services', services


  app

Suki.Controller = require './Controller'
Suki.SequelizeModel = require './SequelizeModel'

global.Suki = module.exports = Suki
