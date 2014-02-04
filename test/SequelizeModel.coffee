assert = require 'assert'
utils  = require '../src/utils'
SequelizeModel = require '../src/SequelizeModel'

describe 'SequelizeModel', ->

  describe '.config', ->
    it 'should support two arguments with key & value', ->
      class A extends SequelizeModel
      A.config 'name', 'A'
      A._config.name.should.eql 'A'

    it 'should support an object', ->
      class B extends SequelizeModel
      B.config
        name: 'B'
        before: 'A'
      B._config.name.should.eql 'B'
      B._config.before.should.eql 'A'

    it 'should share configures bewteen instances', ->
      class A extends SequelizeModel
      class B extends SequelizeModel
      A.config nameA: 'A'
      B.config nameB: 'B'
      A._config.should.not.have.property 'nameB'
      B._config.should.not.have.property 'nameA'

  describe '.models', ->
    it 'should store all the models', ->
      class A extends SequelizeModel
      A.modelName = 'A'
      class B extends SequelizeModel
      B.modelName = 'B'

      sequelize = define: (name) -> name
      A._initModel sequelize
      B._initModel sequelize

      A.models.should.eql A: 'A', B: 'B'
      B.models.should.eql A: 'A', B: 'B'
