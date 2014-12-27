curried = require './curried'

module.exports =
  get: curried (key, obj) -> obj[key]
  set: curried (key, obj, val) -> obj[key] = val
  method: (methodName, args...) -> (obj, moreArgs...) ->
    if moreArgs.length == 0
      # This is just a nicer common case, as it saves us a few __slices.
      obj[methodName](args...)
    else
      obj[methodName](args..., moreArgs...)
