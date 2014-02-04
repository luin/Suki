module.exports = class
  @models: {}

  @config: (key, value) ->
    if typeof key is 'object'
      @config _key, _value for own _key, _value of key
    else
      @_config = {} unless @_config
      @_config[key] = value

  @_initModel: (sequelize) ->
    @_config = {} unless @_config
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

    properties = {}
    for own propertyName, propertyDefination of @prototype
      continue if typeof propertyDefination is 'function'
      properties[propertyName] = propertyDefination

    @model = sequelize.define @modelName, properties, @_config

    @models[@modelName] = @model

  @_initAssociations: ->
    ['hasOne', 'hasMany', 'belongsTo'].forEach (name) =>
      if @["_#{name}"]
        for item in @["_#{name}"]
          model = @models[item.modelName]
          @model[name] model, item.option

  @hasOne: (modelName, option) ->
    @_hasOne = [] unless @__hasOne
    @_hasOne.push
      modelName: modelName
      option: option

  @hasMany: (modelName, option) ->
    @_hasMany = [] unless @__hasMany
    @_hasMany.push
      modelName: modelName
      option: option

  @belongsTo: (modelName, option) ->
    @_belongsTo = [] unless @__belongsTo
    @_belongsTo.push
      modelName: modelName
      option: option
