module.exports = class
  @models: {}

  @_type: 'Sequelize'
  @_initModel: (Sequelize, sequelize) ->
    isPrivateMethod = (methodName) ->
      ~['constructor', 'belongsTo', 'hasMany', 'hasOne'].indexOf(methodName) or
      methodName[0] is '_'

    ['instanceMethods', 'classMethods'].forEach (name) =>
      @_config[name] = {} unless @_config[name]
      where = if name is 'instanceMethods' then @prototype else @
      for own methodName, method of where
        continue unless typeof method is 'function'
        continue if isPrivateMethod methodName
        @_config[name][methodName] = method

    @model = sequelize.define @modelName,
      @_define?(Sequelize),
      @_config

    @models[@modelName] = @model

  @_initAssociations: ->
    ['hasOne', 'hasMany', 'belongsTo'].forEach (name) =>
      if @["__#{name}"]
        for item in @["__#{name}"]
          model = @models[item.modelName]
          @model[name] model, item.option

  @_hasOne: (modelName, option) ->
    @__hasOne = [] unless @__hasOne
    @__hasOne.push
      modelName: modelName
      option: option

  @_hasMany: (modelName, option) ->
    @__hasMany = [] unless @__hasMany
    @__hasMany.push
      modelName: modelName
      option: option

  @_belongsTo: (modelName, option) ->
    @__belongsTo = [] unless @__belongsTo
    @__belongsTo.push
      modelName: modelName
      option: option
