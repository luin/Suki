exports.mapControllerToRoute = (app, Controller) ->
  for own method, data of Controller.supportMethods
    do (method, data) ->
      unless Controller.prototype[method] then return

      routerName = exports.inflection.toRouter Controller.moduleName
      idName     = exports.inflection.toId Controller.moduleName
      modelName  = exports.inflection.toModel Controller.moduleName
      instanceName  = exports.inflection.toInstance Controller.moduleName
      url = data.url
        .replace('{{module}}', routerName)
        .replace('{{id}}', ":#{idName}")

      middlewares = data.middlewares or []
      middlewares.unshift exports.resolvePromise

      middlewares.push (req, res, next) ->
        instance = new Controller()
        instance.req = req
        instance.res = res
        instance.next = next
        models = app.get 'models'
        instance.db = {}
        for model in models
          instance.db[model.modelName] = model.model

        if req.params[idName] and instance.db[modelName]
          instance.db[modelName]
            .find(req.params[idName]).complete (err, result) ->
              instance["_#{instanceName}"] = result
              instance[method]()
        else
          instance[method]()

      app[data.verb] url, middlewares
      console.log data.verb, url

isPromise =(v) ->
  v isnt null && typeof v is 'object' && typeof v.complete is 'function'

resolveAsync = (object, callback) ->
  unless object and typeof object is 'object'
    return callback null, object

  if isPromise object
    return object.complete callback

  if typeof object.toJSON is 'function'
    object = object.toJSON()
    unless object and typeof object is 'object'
      return callback null, object

  remains = []
  for own key, value of object
    if isPromise value
      object[key].key = key
      remains.push value
    else if typeof value is 'object'
      remains.push
        key: key

  unless remains.length
    return callback null, object

  pending = remains.length

  remains.forEach (item) ->
    handleDone = (err, result) ->
      return callback err if err

      object[item.key] = result
      callback null, object if --pending is 0
    if isPromise(item)
      item.complete handleDone
    else
      resolveAsync object[item.key], handleDone


exports.resolvePromise = (req, res, next) ->
  originalResJson = res.json.bind res
  res.json = (args...) ->
    body = args[0]
    if 2 is args.length
      # res.json(body, status) backwards compat
      if 'number' is typeof args[1]
        status = args[1]
      else
        status = body
        body = args[1]

    resolveAsync body, (err, result) ->
      return next err if err
      if typeof status is 'undefined'
        originalResJson result
      else
        originalResJson status, result

  next()

inflection = require 'inflection'
exports.inflection =
  toRouter: (name) -> inflection.pluralize name.toLowerCase()
  toModel : (name) -> inflection.singularize inflection.camelize name
  toId    : (name) ->
    "#{inflection.singularize inflection.camelize name, true}Id"
  toInstance: (name) ->
    inflection.singularize inflection.camelize name, true

