module.exports = class extends Suki.SequelizeModel
  @_config:
    tableName: 'tasks'

  @_define: (DataTypes) ->
    title: DataTypes.STRING

  @belongsTo 'User'


  name: ->
    "This is #{@title}"
