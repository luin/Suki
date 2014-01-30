utils = require '../src/utils'

describe 'utils', ->
  describe '.di', ->
    it 'should return the arguments list', ->
      func1 = (a, b, c) ->
      utils.di(func1).should.eql ['a', 'b', 'c']

      # Test cache
      utils.di(func1).should.eql ['a', 'b', 'c']

      func2 = ->
      utils.di(func2).should.eql []

  describe '.clone', ->
    it 'should clone a object', ->
      obj1 =
        a: 'a'
        b:
          c: 'c'
          d: 'd'
      obj2 = utils.clone obj1
      obj2.should.eql obj1
      obj2.b.c = 'd'
      obj1.b.c.should.eql 'c'

  describe '.splitByCapital', ->
    it 'should split a word by captials', ->
      utils.splitByCapital('showYourName').should.eql ['show', 'your', 'name']
      utils.splitByCapital('show').should.eql ['show']
      utils.splitByCapital('showBooks').should.eql ['show', 'books']

  describe '.capitalize', ->
    it 'should capitalize the word', ->
      utils.capitalize('name').should.eql 'Name'
      utils.capitalize('nameBoy').should.eql 'NameBoy'

  describe '.inflection', ->
    describe '.toRouter', ->
      it 'should return a router name', ->
        utils.inflection.toRouter('User').should.eql 'users'
        utils.inflection.toRouter('user').should.eql 'users'
        utils.inflection.toRouter('users').should.eql 'users'

    describe '.toModel', ->
      it 'should return a model name', ->
        utils.inflection.toModel('User').should.eql 'User'
        utils.inflection.toModel('user').should.eql 'User'
        utils.inflection.toModel('users').should.eql 'User'

    describe '.toId', ->
      it 'should return a id name', ->
        utils.inflection.toId('User').should.eql 'userId'
        utils.inflection.toId('user').should.eql 'userId'
        utils.inflection.toId('users').should.eql 'userId'

    describe '.toInstance', ->
      it 'should return a id name', ->
        utils.inflection.toInstance('User').should.eql 'user'
        utils.inflection.toInstance('user').should.eql 'user'
        utils.inflection.toInstance('users').should.eql 'user'
