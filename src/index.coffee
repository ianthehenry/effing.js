f = require './to-function'

for module in ['math', 'logic', 'objects', 'other', 'relations', 'functions']
  for own key, value of require "./#{module}"
    f[key] = value

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

f.overloaded = require './overloaded'

module.exports = f
