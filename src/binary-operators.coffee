partiallyApplyRightOperand = (fn) -> (b) ->
  switch arguments.length
    when 0 then throw new Error "Operators can't be invoked with no arguments"
    when 1 then (a) ->
      if arguments.length == 0
        throw new Error "Partially applied binary operator can't be invoked with no arguments"
      fn.call this, a, b
    else fn.apply(null, arguments)

module.exports = (ops) ->
  result = {}
  for own key, val of ops
    result[key] = partiallyApplyRightOperand val
  result
