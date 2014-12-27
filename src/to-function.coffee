noop = ->

isArray = Array.isArray ? (x) ->
  Object::toString.call(x) == '[object Array]'

isFunction = (x) -> typeof x == 'function'
isString = (x) -> typeof x == 'string'

toFunction = (functionoid...) ->
  if functionoid.length == 0
    return noop
  if !functionoid[0]?
    return noop

  if typeof functionoid[0] == 'function'
    [fn, args...] = functionoid
    if args.length == 0
      return fn
    else
      return -> fn.call(this, args..., arguments...)

  [target, method, args...] = functionoid
  fn = if isString method
    target[method]
  else if isFunction method
    method
  else
    throw new Error "The [target, method, args...] functionoid requires a string or a function as the method"

  return -> fn.call(target, args..., arguments...)

module.exports = toFunction
