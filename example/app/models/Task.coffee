module.exports = class extends Suki.SequelizeModel
  @config:
    tableName: 'tasks'

  @define: (DataTypes) ->
    title: DataTypes.STRING
    gender:
      type: DataTypes.BOOLEAN
      allowNull: false
      defaultValue: true

