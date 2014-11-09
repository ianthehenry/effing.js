f = require './to-function'

biggestSmallerThanOrEqualTo = (list, target) ->
  smaller = list.filter (x) -> x <= target
  if smaller.length == 0
    return null
  Math.max.apply(null, smaller)

module.exports = (originalMap) ->
  if arguments.length != 1
    throw new Error "overloaded is not overloaded!"
  map = {}
  nums = for own key, val of originalMap
    num = Number key
    if key == '' || isNaN num
      throw new Error "non-numeric key #{key}"
    map[num] = f val
    num
  if nums.length == 0
    throw new Error "you must pass at least one overload!"
  return ->
    len = arguments.length
    fn = map[len] ? do ->
      len = biggestSmallerThanOrEqualTo nums, len
      if len == null
        throw new Error "function not overloaded to accept #{arguments.length} arguments"
      map[len]
    fn.apply this, arguments
