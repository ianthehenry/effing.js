f = require './to-function'
cherry = require './cherry'

module.exports =
  noop: ->

  compose: (a, b) ->
    a = f a
    b = f b
    return ->
      a.call this, b.apply(this, arguments)

  swap: (fn) ->
    fn = f fn
    return (a, b) ->
      fn.call(this, b, a)

  unpack: (fn) ->
    fn = f fn
    return (arg) -> fn.apply(this, arg)

  guard: (fn, pred, elseValue) ->
    fn = f fn
    pred = f pred
    return ->
      if pred.apply this, arguments
        fn.apply this, arguments
      else
        elseValue

  const: (val) -> -> val

  once: (fn, errorMessage = "Function called more than once!") ->
    cherry
      first: fn
      later: -> throw new Error errorMessage
