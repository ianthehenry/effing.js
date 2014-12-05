curried = require './curried'

module.exports =
  get: curried (key, obj) -> obj[key]
  set: curried (key, obj, val) -> obj[key] = val
  method: curried (methodName, obj, args...) ->
    obj[methodName](args...)
  , 2
