f = require './to-function'

# Since Browserify does static analysis to determine file concatenation
# order, we can't do the obvious thing require these in a loop -- we
# have to suck it up and write everything out.
objRequires = [
  require './math' 
  require './logic'
  require './objects'
  require './relations'
  require './functions'
]

for obj in objRequires
  for own key, value of obj
    f[key] = value

f.overloaded = require './overloaded'
f.curried = require './curried'
f.prime = require './prime'

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
