overloaded = require './overloaded'

curry = (fn) ->
  overloaded
    1: (b) -> overloaded 1: (a) -> fn.call this, a, b
    2: fn

module.exports = (ops) ->
  result = {}
  for own key, val of ops
    result[key] = curry val
  result
