module.exports = class extends Suki.Controller

  # POST /tasks
  create: (Task) ->
    task = Task.create { title: @req.body.title }
    @res.json task

  # GET /tasks
  index: (Task) ->
    @res.json
      controller: @req.controller
      action: @req.action
    # @res.json Task.findAll()

  # GET /tasks/:id
  show: ->
    @res.json @task

  # DELETE /tasks/:id
  destroy: ->
    @task.destroy()
    @res.json { "message": "deleted" }


  _needLogin: ->
    console.log 'needLogin'
    @next()

  # load: (Task) ->
  #   @next()
  #   # @next Task.find @id

