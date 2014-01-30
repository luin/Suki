inflect = require 'inflection'

inflection = exports.inflection =
  toRouter: (name) ->
    inflect.pluralize name.toLowerCase()
  toModel: (name) ->
    inflect.singularize inflect.camelize name
  toId: (name) ->
    "#{inflect.singularize inflect.camelize name.toLowerCase(), true}Id"
  toInstance: (name) ->
    inflect.singularize inflect.camelize name.toLowerCase(), true

exports.capitalize = (word) ->
  word.charAt(0).toUpperCase() + word.slice 1

exports.di = (fn) ->
  fn = fn.toString()
  return exports.di.cache[fn] if exports.di.cache[fn]
  FN_ARGS = /^function\s*[^\(]*\(\s*([^\)]*)\)/m
  FN_ARG_SPLIT = /,/
  FN_ARG = /^\s*(_?)(\S+?)\1\s*$/
  STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg
  inject = []
  fnText = fn.replace STRIP_COMMENTS, ''
  argDecl = fnText.match FN_ARGS
  argDecl[1].split(FN_ARG_SPLIT).forEach (arg) ->
    arg.replace FN_ARG, (all, underscore, name) ->
      inject.push name

  exports.di.cache[fn] = inject

exports.di.cache = {}

clone = exports.clone = (obj) ->
  return obj if obj is null or typeof (obj) isnt "object"
  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])

  temp

exports.splitByCapital = (word) ->
  inflect.underscore(word).split '_'

exports.storeNames = (instance, moduleName) ->
  instance.moduleName    = moduleName
  instance.routerName    = inflection.toRouter moduleName
  instance.idName        = inflection.toId moduleName
  instance.modelName     = inflection.toModel moduleName
  instance.instanceName  = inflection.toInstance moduleName
  instance
