operators = require './binary-operators'

module.exports = operators
  gt: (a, b) -> a > b
  gte: (a, b) -> a >= b
  lt: (a, b) -> a < b
  lte: (a, b) -> a <= b
  eq: (a, b) -> a == b
  neq: (a, b) -> a != b
