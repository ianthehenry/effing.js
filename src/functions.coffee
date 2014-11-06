f = require './functionoid'

curried = (fn, length) ->
  if !length?
    if typeof fn == 'function'
      length = fn.length
    else
      throw new Error "You can't get a curried version of a functionoid without specifying an explicit number of expected parameters!"
  fn = f fn
  return ->
    if arguments.length < length
      curried f([fn, arguments...]), length - arguments.length
    else
      fn.apply this, arguments

module.exports =
  noop: ->

  compose: (a, b) ->
    a = f a
    b = f b
    return ->
      a.call this, b.apply(this, arguments)

  curried: curried

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
    fn = f fn
    called = false
    return ->
      if called
        throw new Error(errorMessage)
      called = true
      fn.apply(this, arguments)

  time: ({first, later, beforeBoth, afterBoth, both}) ->
    first = f first
    later = f later
    beforeBoth = f beforeBoth
    afterBoth = f (afterBoth ? both)
    isFirst = true
    return ->
      beforeBoth.apply(this, arguments)
      if isFirst
        first.apply(this, arguments)
      else
        isFirst = true
        later.apply(this, arguments)
      afterBoth.apply(this, arguments)
