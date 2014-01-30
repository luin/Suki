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
      app = {}
      ['get', 'post', 'put', 'patch', 'delete'].forEach (method) ->
        app[method] = (url, middlewares) ->
          app.url = url
          app["_#{method}"] = middlewares

      req = { app: app, params: [] }
      res = {}

    describe 'basic map', ->
      it 'should map index method correctly', (done) ->
        class User extends Controller
          index: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users'
        invokeMiddlewares app._get

      it 'should map show method correctly', (done) ->
        class User extends Controller
          show: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._get

      it 'should map delete method correctly', (done) ->
        class User extends Controller
          destroy: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._delete

      it 'should map patch method correctly', (done) ->
        class User extends Controller
          patch: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._patch

      it 'should map patch method correctly', (done) ->
        class User extends Controller
          patch: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._patch

      it 'should map create method correctly', (done) ->
        class User extends Controller
          create: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users'
        invokeMiddlewares app._post

      it 'should map new method correctly', (done) ->
        class User extends Controller
          new: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/new'
        invokeMiddlewares app._get

      it 'should map edit method correctly', (done) ->
        class User extends Controller
          edit: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId/edit'
        invokeMiddlewares app._get

      it 'should map update method correctly', (done) ->
        class User extends Controller
          update: ->
            req.app.should.equal app
            done()

        utils.storeNames User, 'User'
        User._mapToRoute app

        app.url.should.eql '/users/:userId'
        invokeMiddlewares app._put

