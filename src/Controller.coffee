module.exports = Controller = class
  @supportMethods =
    get:
      verb: 'get'
      url: '/{{module}}/{{id}}'
    index:
      verb: 'get'
      url: '/{{module}}'
    destroy:
      verb: 'delete'
      url: '/{{module}}/{{id}}'
    create:
      verb: 'post'
      url: '/{{module}}'
    update:
      verb: 'put'
      url: '/{{module}}/{{id}}'
    patch:
      verb: 'patch'
      url: '/{{module}}/{{id}}'

  @before: (method, middlewares...) ->
    unless @supportMethods[method]
      throw new Error "Unsupported method: #{method}"

    unless @supportMethods[method].middlewares
      @supportMethods[method].middlewares = []

    for middleware in middlewares
      @supportMethods[method].middlewares.push middleware

  @beforeAll: (middlewares...) ->
    for own method of @supportMethods
      @before method, middlewares...

