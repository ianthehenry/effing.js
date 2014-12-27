relations = require 'effing/relations'
math = require 'effing/math'
{ assert } = require 'chai'

describe "binary operators", ->
  it "partially apply their right operand when passed a single argument", ->
    isUnderage = relations.lt(18)
    assert isUnderage(5)
    assert !isUnderage(20)

  it "allow more than one argument to the curried form", ->
    addTen = math.add(10)
    assert addTen(5, 'foo', 'bar') == 15

  it "do not allow zero arguments to the curried form", ->
    addTen = math.add(10)
    assert.throws -> addTen()

  it "do the right thing with two arguments", ->
    assert math.add(10, 5) == 15
