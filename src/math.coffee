module.exports =
  add: (a, b) -> a + b
  subtract: (a, b) -> a - b
  multiply: (a, b) -> a * b
  divide: (a, b) -> a / b
  divideInt: (a, b) -> Math.floor(a / b)
  modulo: (a, b) -> (a % b + b) % b
  remainder: (a, b) -> a % b
  negate: (a) -> -a
