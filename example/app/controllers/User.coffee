module.exports = class extends Suki.Controller

  index: ->
    @res.json
      controller: @req.controller
      action: @req.action

  show: ->
    @res.json @user


  # Task
  indexTask: (Task) ->
    @res.json @user.getTasks()

  showTask: (Task) ->
    @res.json
      name: @task.name()

  loadTask: (Task) ->
    console.log '======LOAD'
    Task.find
      where:
        id: @req.params.taskId
    .complete (err, task) =>
      @task = task
      @next()

