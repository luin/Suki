utils = require './utils'
async = require 'async'

module.exports = Controller = class
  @baseURL = ''

  load: ->
    klass = @constructor
    if @req.params[klass.idName] and @req.app.get klass.modelName
      @req.app.get(klass.modelName)
        .find(@req.params[klass.idName]).complete (err, result) =>
          unless err
            @[klass.instanceName] = result
          @next err
    else
      @next()

  @supportActions =
    index:
      method: 'get'
      url: '/{{module}}'
    new:
      method: 'get'
      url: '/{{module}}/new'
    create:
      method: 'post'
      url: '/{{module}}'
    show:
      method: 'get'
      url: '/{{module}}/{{id}}'
    edit:
      method: 'get'
      url: '/{{module}}/{{id}}/edit'
    update:
      method: 'put'
      url: '/{{module}}/{{id}}'
    patch:
      method: 'patch'
      url: '/{{module}}/{{id}}'
    destroy:
      method: 'delete'
      url: '/{{module}}/{{id}}'

  @before: (action, condition) ->
    unless @_beforeActions
      @_beforeActions = []

    if condition
      if typeof condition.only is 'string'
        condition.only = [condition.only]
      if typeof condition.except is 'string'
        condition.except = [condition.except]

    @_beforeActions.push
      action: action
      condition: condition

  _fetchInjections: (actionName) ->
    [req, res] = [@req, @res]
    services = req.app.get 'suki.services'
    getInjections = (fn) ->
      injections = utils.di fn
      injections.map (injection) ->
        if req.app.get injection
          (callback) ->
            callback null, req.app.get injection
        else if services?[injection]
          (callback) ->
            services[injection] req, res, callback

        else throw new Error "Can't find the injection #{injection}"

    injections = getInjections @[actionName]
    async.parallel injections, (err, result) =>
      if err
        @next err
      else
        @[actionName] result...

  @_mapToRoute: (app) ->
    for own action, body of @prototype
      do (action, body) =>
        return unless typeof body is 'function'
        splitedAction = utils.splitByCapital action
        actionList = Object.keys @supportActions
        return unless actionList.some (actionPrefix) ->
          actionPrefix is splitedAction[0]

        resources = []
        for item, index in splitedAction
          if index is 0
            resources.push @
            resources.action = item
          else
            resources.push item

        resources.url = ''
        for resource, index in resources
          routerName =
            if resource is @ then @routerName
            else utils.inflection.toRouter resource
          idName =
            if resource is @ then @idName
            else utils.inflection.toId resource
          baseAction =
            if index is resources.length - 1 then resources.action
            else 'show'
          definition = @supportActions[baseAction]

          resources.url += definition.url
            .replace('{{module}}', routerName)
            .replace('{{id}}', ":#{idName}")

        middlewares = []

        # Store the controller instance in the `req`
        middlewares.push (req, res, next) =>
          instance = new @
          instance.req = req
          instance.req.controller = @modelName
          instance.req.action = action
          instance.res = res
          req.__suki_controller_instance = instance
          next()

        # Auto load
        currentLoadActionName = ''
        needLoad = ~@supportActions[resources.action].url.indexOf '{{id}}'
        for resource, index in resources
          do (resource, index) =>
            isntLastResouce = index isnt resources.length - 1
            if resource is @
              if @prototype.load and (isntLastResouce or needLoad)
                middlewares.push (req, res, next) ->
                  instance = req.__suki_controller_instance
                  instance.next = next
                  instance._fetchInjections 'load'
            else
              currentLoadActionName += utils.capitalize resource
              loadActionName = "load#{currentLoadActionName}"
              if @prototype[loadActionName] and
                  (isntLastResouce or needLoad)
                middlewares.push (req, res, next) ->
                  instance = req.__suki_controller_instance
                  instance.next = next
                  instance._fetchInjections loadActionName

        # Apply beforeAction
        if @_beforeActions
          @_beforeActions.forEach (beforeAction) ->
            if beforeAction.condition
              if beforeAction.only
                return unless ~beforeAction.only.indexOf action
              else if beforeAction.except
                return unless beforeAction.except.indexOf action

            if typeof beforeAction.action is 'string'
              middlewares.push (req, res, next) ->
                instance = req.__suki_controller_instance
                instance.next = next
                instance._fetchInjections beforeAction.action
            else if typeof beforeAction.action is 'function'
              middlewares.push beforeAction.action

        middlewares.push (req, res, next) ->
          instance = req.__suki_controller_instance
          instance.next = next
          instance._fetchInjections action

        method = @supportActions[resources.action].method
        app[method] @baseURL + resources.url, middlewares
