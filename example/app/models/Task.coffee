module.exports = class extends Suki.SequelizeModel

  @belongsTo 'User'
  @config 'tableName', 'task'

  title: Sequelize.STRING
  age:   Sequelize.STRING


  name: ->
    "This is #{@title}"
