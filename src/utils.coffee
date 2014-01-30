inflection = require 'inflection'
exports.inflection =
  toRouter: (name) ->
    inflection.pluralize name.toLowerCase()
  toModel: (name) ->
    inflection.singularize inflection.camelize name
  toId: (name) ->
    "#{inflection.singularize inflection.camelize name, true}Id"
  toInstance: (name) ->
    inflection.singularize inflection.camelize name, true

exports.capitalize = (word) ->
  word.charAt(0).toUpperCase() + word.slice 1

exports.di = (fn) ->
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

  inject

clone = exports.clone = (obj) ->
  return obj if obj is null or typeof (obj) isnt "object"
  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])

  temp

exports.splitByCapital = (word) ->
  inflection.underscore(word).split '_'

