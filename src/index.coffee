f = require './to-function.coffee'

for file in ['math', 'logic', 'objects', 'relations', 'functions']
  for own key, value of require "./#{file}.coffee"
    f[key] = value

for name in ['overloaded', 'curried', 'prime']
  f[name] = require "./#{name}.coffee"

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

for own newName, oldName of aliases
  f[newName] = f[oldName]

module.exports = f
