operators = require './binary-operators'

module.exports = operators
  and: (a, b) -> a && b
  or: (a, b) -> a || b

module.exports.not = (a) -> !a
