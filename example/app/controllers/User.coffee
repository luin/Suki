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
    Task.find
      where:
        id: @req.params.taskId
    .complete (err, task) =>
      name = task.name()
      @res.json
        name: name

