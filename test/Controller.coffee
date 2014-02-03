assert = require 'assert'
utils  = require '../src/utils'
Controller = require '../src/Controller'

describe 'Controller', ->

  describe '.supportActions', ->
    it 'should be a object', ->
      Controller.supportActions.should.be.type 'object'

    it 'should share between instances', ->
      class A extends Controller
      oldShow = A.supportActions.show
      A.supportActions.show = 1

      class B extends Controller

      A.supportActions.show.should.eql 1
      B.supportActions.show.should.eql 1

      Controller.supportActions.show = oldShow

  describe '.before', ->
    it 'should not share before-actions between instances', ->
      class A extends Controller
      A.before '_test_share'
      class B extends Controller
      assert not B._beforeActions

    describe 'without `condition`', ->
      it 'should apply the action to the all methods', ->
        class A extends Controller
        A.before '_test_all'
        A._beforeActions.should.have.lengthOf 1
        A._beforeActions[0].action.should.eql '_test_all'
        assert not A._beforeActions[0].condition

    describe 'with `only`', ->
      it 'should only affect the specific methods', ->
        class A extends Controller
        A.before '_test_only', only: ['patch', 'show']
        A._beforeActions.should.have.lengthOf 1
        A._beforeActions[0].action.should.eql '_test_only'
        A._beforeActions[0].condition.should.eql
          only: ['patch', 'show']

    describe 'with `except`', ->
      it 'should only affect the other methods', ->
        class A extends Controller
        A.before '_test_except', except: ['patch', 'put']
        A._beforeActions.should.have.lengthOf 1
        A._beforeActions[0].action.should.eql '_test_except'
        A._beforeActions[0].condition.should.eql
          except: ['patch', 'put']

  describe '._mapToRoute', ->
    app = req = res = null
    invokeMiddlewares = (middlewares) ->
      continueMiddleware = (index) ->
        middlewares[index] req, res, ->
          continueMiddleware index + 1

      continueMiddleware 0

    beforeEach ->
      # Mock app
      objects = {}
      app = {}
      ['get', 'post', 'put', 'patch', 'delete'].forEach (method) ->
        app[method] = (url, middlewares) ->
          if method is 'get' and not middlewares
            return objects[url]
          app.url = url
          app["_#{method}"] = middlewares

      app.set = (key, value) -> objects[key] = value

      req = { app: app, params: {} }
      res = {}

    describe 'basic map', ->
      it 'should map index method correctly', (done) ->
        class User extends Controller
          index: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users'
        invokeMiddlewares app._get

      it 'should map show method correctly', (done) ->
        class User extends Controller
          show: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._get

      it 'should map delete method correctly', (done) ->
        class User extends Controller
          destroy: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._delete

      it 'should map patch method correctly', (done) ->
        class User extends Controller
          patch: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._patch

      it 'should map create method correctly', (done) ->
        class User extends Controller
          create: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users'
        invokeMiddlewares app._post

      it 'should map new method correctly', (done) ->
        class User extends Controller
          new: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/new'
        invokeMiddlewares app._get

      it 'should map edit method correctly', (done) ->
        class User extends Controller
          edit: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId/edit'
        invokeMiddlewares app._get

      it 'should map update method correctly', (done) ->
        class User extends Controller
          update: ->
            @req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._put

      it 'should invoke the load method when fetch a instance', (done) ->
        class User extends Controller
          show: (@user) ->
            @user.should.have.property 'name', 'boy'
            @req.app.should.equal app
            done()

          loadUser: ->
            @next null, name: 'boy'

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        req.params =
          userId: 123
        invokeMiddlewares app._get

    describe 'nested map', ->
      it 'shoud map nested resource correctly', (done) ->
        class User extends Controller
          showTask: (@user, @task) ->
            @req.app.should.equal app
            @user.should.have.property('name', 'boy')
            @task.should.have.property('title', 'todo')
            done()

          loadUser: ->
            @next null, name: 'boy'

          loadTask: ->
            @next null, title: 'todo'

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId/tasks/:taskId'
        req.params =
          userId: 123
          taskId: ''
        invokeMiddlewares app._get

      it 'shoud invoke the `load` methods correctly', (done) ->
        class User extends Controller
          indexTaskComment: (@task, @user) ->
            @req.app.should.equal app
            @user.should.have.property('name', 'boy')
            @task.should.have.property('title', 'todo')
            done()

          loadUser: ->
            @next null, name: 'boy'

          loadTask: ->
            @next null, title: 'todo'

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId/tasks/:taskId/comments'
        req.params =
          userId: 123
          taskId: 0
        invokeMiddlewares app._get

      it 'shoud invoke the model with the same name by default', (done) ->
        app.set 'modelTask',
          find: (id) ->
            id.should.eql '9976'
            {
              complete: (callback) ->
                callback null, title: 'todo'
            }
        class User extends Controller
          indexTaskComment: (@task, @user) ->
            @req.app.should.equal app
            @user.should.have.property('name', 'boy')
            @task.should.have.property('title', 'todo')
            done()

          loadUser: ->
            @next null, name: 'boy'

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId/tasks/:taskId/comments'
        req.params =
          userId: 123
          taskId: '9976'
        invokeMiddlewares app._get
