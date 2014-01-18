describe 'User', ->
  describe '#index', ->
    it 'should return all users', (done) ->
      app.get('/users').expect 200, done


