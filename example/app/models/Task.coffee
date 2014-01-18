module.exports = class extends require('../../../src').Model

  @defineProperties: (DataTypes) ->
    title: DataTypes.STRING
