functions = require 'effing/functions'
{ assert } = require 'chai'

describe "compose", ->
  it "calls in the right order", ->
    inc = (x) -> x + 1
    double = (x) -> x * 2
    assert functions.compose(inc, double)(5) == 11
    assert functions.compose(double, inc)(5) == 12

  it "accepts functionoids", ->
    add = (a, b) -> a + b
    mult = (a, b) -> a * b
    assert functions.compose([add, 1], [mult, 2])(5) == 11
    assert functions.compose([mult, 2], [add, 1])(5) == 12

describe "concat", ->
  it "calls inner functions with the same arguments", ->
    list = []
    inc = (a) -> list.push(a + 1)
    double = (a) -> list.push(a * 2)
    functions.concat(double, inc, inc, double)(5)
    assert.deepEqual list, [10, 6, 6, 10]

  it "returns the value of the last inner function", ->
    five = -> 5
    six = -> 6
    seven = -> 7
    assert functions.concat(five, six, seven)() == 7

  it "accepts functionoids", ->
    list = []
    add = (a, b) -> list.push(a + b)
    mult = (a, b) -> list.push(a * b)
    functions.concat([mult, 2], [add, 1], [add, 2], [mult, 3])(5)
    assert.deepEqual list, [10, 6, 7, 15]
