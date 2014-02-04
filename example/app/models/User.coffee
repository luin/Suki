module.exports = class extends Suki.SequelizeModel

  @config: tableName: 'users'

  name: Sequelize.STRING
  gender:
    type: Sequelize.BOOLEAN
    allowNull: false
    defaultValue: true

  @hasMany 'Task'
