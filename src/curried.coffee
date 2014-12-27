f = require './to-function'

curried = (fn, length = fn.length) ->
  return ->
    if arguments.length < length
      curried f(fn, arguments...), length - arguments.length
    else
      fn.apply this, arguments

module.exports = curried
