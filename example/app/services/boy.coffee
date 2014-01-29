module.exports = (req, res, next) ->
  next null,
    name: 'boy'
    gender: 'male'
