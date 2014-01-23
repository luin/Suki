module.exports = class extends Suki.Controller
  @belongTo: 'User'
  @beforeAction '_needLogin', only: 'index'
  # @beforeAction (controller) ->
  #   controller.name = 1
  #   controller.next new Error '404'
  # , only: 'create'

  # POST /tasks
  create: (Task) ->
    task = Task.create { title: @req.body.title }
    @res.json task

  # GET /tasks
  index: (Task) ->
    @res.json Task.findAll()

  # GET /tasks/:id
  show: ->
    @res.json @_task

  # DELETE /tasks/:id
  destroy: ->
    @_task.destroy()
    @res.json { "message": "deleted" }


  _needLogin: ->
    console.log 'needLogin'
    @next()
