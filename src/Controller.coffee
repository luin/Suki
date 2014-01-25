utils = require './utils'

module.exports = Controller = class
  supportMethods =
    index:
      verb: 'get'
      url: '/{{module}}'
    new:
      verb: 'get'
      url: '/{{module}}/new'
    create:
      verb: 'post'
      url: '/{{module}}'
    show:
      verb: 'get'
      url: '/{{module}}/{{id}}'
    edit:
      verb: 'get'
      url: '/{{module}}/edit'
    update:
      verb: 'put'
      url: '/{{module}}/{{id}}'
    patch:
      verb: 'patch'
      url: '/{{module}}/{{id}}'
    destroy:
      verb: 'delete'
      url: '/{{module}}/{{id}}'

  @initialize: ->
    Object.defineProperty @, 'supportMethods',
      get: ->
        unless @_supportMethods
          @_supportMethods = utils.clone supportMethods
        @_supportMethods
    @

  @beforeAction: (action, condition) ->
    # Calc condition
    targetMethods =
      if condition
        if condition.only and condition.except
          throw new Error 'Cannot use `only` and `except` at the same time.'

        if condition.only
          if typeof condition.only is 'string'
            condition.only = [condition.only]
          condition.only
        else if condition.except
          if typeof condition.except is 'string'
            condition.except = [condition.except]
          Object.keys(@supportMethods).filter (item) ->
            -1 is condition.except.indexOf item
      else
        Object.keys @supportMethods

    for method in targetMethods
      unless @supportMethods[method]
        throw new Error "Unsupported action name `#{method}`"

      unless @supportMethods[method].beforeActions
        @supportMethods[method].beforeActions = []

      @supportMethods[method].beforeActions.push action

  @_mapToRoute: (app, option) ->
    # Get models
    models = app.get 'models'

    # define getInjections
    injectionsCache = {}
    getInjections = (fn) ->
      fn = fn.toString()
      injections =
        if injectionsCache[fn]
          injectionsCache[fn]
        else
          injectionsCache[fn] = utils.di(fn)
      injections.map (injection) ->
        if app.get injection then app.get injection
        else throw new Error "Can't find the injection #{injection}"

    for own method, data of @supportMethods
      do (method, data) =>
        return unless @prototype[method]

        routerName = utils.inflection.toRouter @moduleName
        idName     = utils.inflection.toId @moduleName
        modelName  = utils.inflection.toModel @moduleName
        instanceName  = utils.inflection.toInstance @moduleName
        url = data.url
          .replace('{{module}}', routerName)
          .replace('{{id}}', ":#{idName}")

        unless option.resolvePromise is false
          middlewares = [utils.resolvePromise]

        # Store instance to `req`
        middlewares.push (req, res, next) =>
          instance = new @()
          instance.req = req
          instance.res = res
          req.__suki_controller_instance = instance
          next()

        # Apply beforeAction
        if data.beforeActions
          data.beforeActions.forEach (action) ->
            middlewares.push (req, res, next) ->
              instance = req.__suki_controller_instance
              instance.next = next
              instance[action] getInjections(instance[action])...

        middlewares.push (req, res, next) ->
          instance = req.__suki_controller_instance
          instance.next = next
          if req.params[idName] and models[modelName]
            models[modelName]
              .find(req.params[idName]).complete (err, result) ->
                instance[instanceName] = result
                instance[method] getInjections(instance[method])...
          else
            instance[method] getInjections(instance[method])...

        app[data.verb] url, middlewares

