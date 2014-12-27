f = require './to-function'

seq = (context, args, fns...) ->
  val = undefined
  for fn in fns when fn?
    val = fn.apply(context, args)
  return val

module.exports = ({ first, after, beforeBoth, afterBoth, both }) ->
  afterBoth = afterBoth ? both

  isFirst = true
  return ->
    seq this, arguments,
      beforeBoth
      if isFirst then isFirst = false; first else after
      afterBoth
