module.exports = class extends Suki.Controller

  index: (boy) ->
    @res.json
      controller: @req.controller
      action: @req.action
      boy: boy

  show: ->
    @res.json @user


  # Task
  indexTask: ->
    @res.json @user.getTasks()

  showTask: ->
    @res.json
      name: @task.name()

  loadTask: ->
    console.log '======LOAD'
    Task.find
      where:
        id: @req.params.taskId
    .complete (err, task) =>
      @task = task
      @next()

