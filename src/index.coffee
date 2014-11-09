f = require './to-function'

for module in ['math', 'logic', 'objects', 'other', 'relations', 'functions']
  for own key, value of require "./#{module}"
    f[key] = value

f.overloaded = require './overloaded'
f.curried = require './curried'

aliases =
  sub: 'subtract'
  mult: 'multiply'
  div: 'divide'
  idiv: 'divideInt'
  mod: 'modulo'
  neg: 'negate'
  rem: 'remainder'

  comp: 'compose'
  dot: 'get'

  is: 'eq'
  isnt: 'neq'

for own newName, oldName of aliases
  f[newName] = f[oldName]

module.exports = f
