f = require './to-function'

curried = (length, fn) ->
  if typeof length == 'function'
    fn = length
    length = fn.length
  return ->
    if arguments.length < length
      curried length - arguments.length, f(fn, arguments...)
    else
      fn.apply this, arguments

module.exports = curried
