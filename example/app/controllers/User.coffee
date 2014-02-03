module.exports = class extends Suki.Controller

  @before '_checkPermission', only: 'createTask'

  # GET /users/:userId
  show: (@user) ->
    @res.render()

  # POST /users
  create: ->
    unless req.body.name or req.body.password
      @next new Error 'Invalid params'
      return

    User.create(name: req.body.name, password: req.body.password)
        .success (user) =>
          @res.json user

  # POST /users/:userId/tasks
  createTask: ->
    unless req.body.title
      @next new Error 'Invalid params'
      return

    Task.create({ title: req.body.title }).success (task) =>
      @user.addTask task
      @res.json task

  # GET /users/:userId/tasks
  listTask: ->
    @res.json @user.getTasks()


  # Private methods
  _checkPermission: (me, @user) ->
    @next()
