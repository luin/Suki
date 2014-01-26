module.exports = class extends Suki.SequelizeModel
  @_config
    tableName: 'users'

  @_define (DataTypes) ->
    name: DataTypes.STRING
    gender:
      type: DataTypes.BOOLEAN
      allowNull: false
      defaultValue: true

  @_hasMany 'Task'
