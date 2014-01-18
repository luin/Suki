app = require '..'
request = require('supertest') app
models = app.get 'models'

describe 'Task', ->
  describe '#index', ->
    it 'should return all tasks', (done) ->
      request.get('/tasks').expect 200, done


