utils = require './utils'

module.exports = Model = class
  @_type: 'Sequelize'
  @_initModel: (Sequelize, sequelize) ->
    @modelName = utils.inflection.toModel @moduleName
    @model = sequelize.define @modelName,
      @define(Sequelize),
      @config
