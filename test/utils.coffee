utils = require '../src/utils'
Sequelize  = require 'sequelize'

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

    describe '.isSequelizeDataType', ->
      isSequelizeDataType = utils.isSequelizeDataType
      it 'should return true when is a datatype', ->
        isSequelizeDataType(Sequelize.STRING).should.be.true
        isSequelizeDataType(Sequelize.STRING(15)).should.be.true
        isSequelizeDataType(Sequelize.STRING.BINARY).should.be.true
        isSequelizeDataType(Sequelize.TEXT).should.be.true
        isSequelizeDataType(Sequelize.INTEGER).should.be.true
        isSequelizeDataType(Sequelize.BIGINT).should.be.true
        isSequelizeDataType(Sequelize.BIGINT(11)).should.be.true
        isSequelizeDataType(Sequelize.FLOAT).should.be.true
        isSequelizeDataType(Sequelize.FLOAT(11)).should.be.true
        isSequelizeDataType(Sequelize.FLOAT(11, 12)).should.be.true
        isSequelizeDataType(Sequelize.DECIMAL).should.be.true
        isSequelizeDataType(Sequelize.DECIMAL(10, 2)).should.be.true
        isSequelizeDataType(Sequelize.DATE).should.be.true
        isSequelizeDataType(Sequelize.BOOLEAN).should.be.true
        isSequelizeDataType(Sequelize.ENUM('value 1', 'vaule 2')).should.be.true
        isSequelizeDataType(Sequelize.ARRAY(Sequelize.TEXT)).should.be.true
        isSequelizeDataType(Sequelize.BLOB).should.be.true
        isSequelizeDataType(Sequelize.BLOB('tiny')).should.be.true
        isSequelizeDataType(Sequelize.UUID).should.be.true

      it 'should return false when isnt a datatype', ->
        a = ->
        b = (a, b, c) ->

        isSequelizeDataType(a).should.be.false
        isSequelizeDataType(b).should.be.false
