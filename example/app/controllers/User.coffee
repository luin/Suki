module.exports = class extends Suki.Controller

  index: ->
    User.findAll().complete (err, tasks) ->
      @res.json tasks

  show: ->
    @res.json @user

  # Task
  indexTask: ->
    @user.getTasks().complete (err, tasks) ->
      @res.json tasks

  showTask: ->
    @res.json
      name: @task.name()

  loadTask: ->
    Task.find
      where:
        id: @req.params.taskId
    .complete (err, task) =>
      @task = task
      @next()

