noop = ->

isArray = Array.isArray ? (x) ->
  Object::toString.call(x) == '[object Array]'

isFunction = (x) -> typeof x == 'function'
isString = (x) -> typeof x == 'string'

module.exports = (functionoid) ->
  if !functionoid?
    return noop
  if isFunction functionoid
    return functionoid
  if !isArray(functionoid)
    throw new Error "Input is not convertible to a function"
  if functionoid.length == 0
    throw new Error "Empty arrays are not functionoids"

  if typeof functionoid[0] == 'function'
    [fn, args...] = functionoid
    return -> fn.call(this, args..., arguments...)

  [target, method, args...] = functionoid
  fn = if isString method
    target[method]
  else if isFunction method
    method
  else
    throw new Error "The [target, method, args...] functionoid requires a string or a function as the method"

  return -> fn.call(target, args..., arguments...)
