assert = require 'assert'
Controller = require '../src/Controller'

describe 'Controller', ->

  describe '.supportActions', ->
    it 'should be a object', ->
      Controller.supportActions.should.be.type 'object'

    it 'should share between instances', ->
      class A extends Controller
      A.supportActions.show = 1

      class B extends Controller

      A.supportActions.show.should.eql 1
      B.supportActions.show.should.eql 1

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
