assert = require 'assert'
Controller = require '../src/Controller'

describe 'Controller', ->

  describe '.supportMethods', ->
    it 'should be a object', ->
      Controller.supportMethods.should.be.type 'object'

    it 'should share between instances', ->
      class A extends Controller
      A.supportMethods.show = 1

      class B extends Controller

      A.supportMethods.show.should.eql 1
      B.supportMethods.show.should.eql 1

  describe '.beforeAction', ->
    describe 'without `condition`', ->
      it 'should apply the action to the all methods', ->
        class A extends Controller
        A.beforeAction '_test_all'
        for own methodName, method of A.supportMethods
          method.beforeActions.should.eql ['_test_all']

    describe 'with `only`', ->
      it 'should only affect the specific methods', ->
        class A extends Controller
        A.beforeAction '_test_only', only: ['patch', 'show']
        for own methodName, method of A.supportMethods
          if methodName is 'patch' or methodName is 'show'
            method.beforeActions.should.eql ['_test_only']
          else
            assert not method.beforeActions

    describe 'with `except`', ->
      it 'should only affect the other methods', ->
        class A extends Controller
        A.beforeAction '_test_except', except: ['patch', 'put']
        for own methodName, method of A.supportMethods
          if methodName is 'patch' or methodName is 'put'
            assert not method.beforeActions
          else
            method.beforeActions.should.eql ['_test_except']
