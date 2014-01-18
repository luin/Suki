module.exports = class extends require('../../..').Controller

  # POST /tasks
  create: ->
    task = @db.Task.create { title: @req.body.title }
    @res.json task

  # GET /tasks
  index: ->
    @res.json @db.Task.findAll()

  # GET /tasks/:id
  get: ->
    @res.json @_task

  # DELETE /tasks/:id
  destroy: ->
    @_task.destroy()
    @res.json { "message": "deleted" }

