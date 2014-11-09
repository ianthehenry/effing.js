operators = require './binary-operators'

module.exports = operators
  add: (a, b) -> a + b
  subtract: (a, b) -> a - b
  multiply: (a, b) -> a * b
  divide: (a, b) -> a / b
  intDivide: (a, b) -> Math.floor(a / b)
  modulo: (a, b) -> (a % b + b) % b
  remainder: (a, b) -> a % b

module.exports.negate = (a) -> -a
