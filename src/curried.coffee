f = require './to-function'

curried = (fn, length) ->
  if !length?
    if typeof fn == 'function'
      length = fn.length
    else
      throw new Error "You can't get a curried version of a functionoid without specifying an explicit number of expected parameters!"
  fn = f fn
  return ->
    if arguments.length < length
      curried f(fn, arguments...), length - arguments.length
    else
      fn.apply this, arguments

module.exports = curried
