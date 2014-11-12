f = require './to-function'

seq = (context, args, fns...) ->
  val = undefined
  for fn in fns when fn?
    val = fn.apply(context, args)
  return val

module.exports = ({ first, after, beforeBoth, afterBoth, both }) ->
  afterBoth = afterBoth ? both

  # this is goofy, but necessary to ensure the return value is good
  if first?
    first = f first
  if after?
    after = f after
  if beforeBoth?
    beforeBoth = f beforeBoth
  if afterBoth?
    afterBoth = f afterBoth

  isFirst = true
  return ->
    seq this, arguments,
      beforeBoth
      if isFirst then isFirst = false; first else after
      afterBoth
