f = require './to-function'
prime = require './prime'

module.exports =
  noop: f()

  id: (a) -> a

  choke: (length, fn) ->
    (args...) ->
      fn.apply(this, args.slice(0, length))

  concat: (fns...) ->
    return ->
      val = undefined
      for fn in fns
        val = fn.apply(this, arguments)
      return val

  compose: (a, b) ->
    return ->
      a.call this, b.apply(this, arguments)

  unpack: (fn) ->
    return (arg) -> fn.apply(this, arg)

  guard: (fn, pred, elseValue) ->
    return ->
      if pred.apply this, arguments
        fn.apply this, arguments
      else
        elseValue

  const: (val) -> -> val

  once: (fn, errorMessage = "Function called more than once!") ->
    prime
      first: fn
      after: -> throw new Error errorMessage
