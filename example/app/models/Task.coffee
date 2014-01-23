module.exports = class extends Suki.Model
  @config:
    tableName: 'tasks'

  @define: (DataTypes) ->
    title: DataTypes.STRING
    gender:
      type: DataTypes.BOOLEAN
      allowNull: false
      defaultValue: true

