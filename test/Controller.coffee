assert = require 'assert'
Controller = require '../src/Controller'

describe 'Controller', ->

  describe '.initialize', ->
    it 'should return self instance', ->
      class InitializedController extends Controller
      InitializedController.initialize().should.eql InitializedController

  describe '.supportMethods', ->
    it 'should be a object', ->
      class InitializedController extends Controller
      InitializedController.initialize()
      InitializedController.supportMethods.should.be.type 'object'

  describe '.beforeAction', ->
    describe 'without `condition`', ->
      it 'should apply the action to the all methods', ->
        class A extends Controller
        A.initialize()
        A.beforeAction '_test'
        for own methodName, method of A.supportMethods
          method.beforeActions.should.eql ['_test']

    describe 'with `only`', ->
      it 'should only affect the specific methods', ->
        class A extends Controller
        A.initialize()
        A.beforeAction '_test_only', only: ['patch', 'show']
        for own methodName, method of A.supportMethods
          if methodName is 'patch' or methodName is 'show'
            method.beforeActions.should.eql ['_test_only']
          else
            assert not method.beforeActions

    describe 'with `except`', ->
      it 'should only affect the other methods', ->
        class A extends Controller
        A.initialize()
        A.beforeAction '_test_except', except: ['patch', 'put']
        for own methodName, method of A.supportMethods
          if methodName is 'patch' or methodName is 'put'
            assert not method.beforeActions
          else
            method.beforeActions.should.eql ['_test_except']







