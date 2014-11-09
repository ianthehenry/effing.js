module.exports = (map) ->
  return ->
    fn = map[arguments.length]
    if !fn?
      throw new Error "function not overloaded to accept #{arguments.length} arguments"
    fn.apply this, arguments
