functions = require 'effing/functions'
{ assert } = require 'chai'

describe "compose", ->
  it "calls in the right order", ->
    inc = (x) -> x + 1
    double = (x) -> x * 2
    assert functions.compose(inc, double)(5) == 11
    assert functions.compose(double, inc)(5) == 12

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

describe "choke", ->
  it "calls the inner function", ->
    sum = (a = 0, b = 0, c = 0) -> a + b + c

    assert sum(1, 2, 3) == 6
    assert functions.choke(2, sum)(1, 2, 3) == 3
    assert functions.choke(1, sum)(1, 2, 3) == 1

  it "is a maximum", ->
    sum = (a = 0, b = 0, c = 0) -> a + b + c
    assert functions.choke(2, sum)(1) == 1

  it "performs function conversion", ->
    statefulSum = (a = 0, b = 0, c = 0) -> a + b + c + @x

    assert functions.choke(1, { x: 10 }, statefulSum)(1) == 11

  it "specifies the number of additional arguments when partially applying", ->
    statefulSum = (a = 0, b = 0, c = 0) -> a + b + c + @x

    assert functions.choke(1, { x: 10 }, statefulSum, 2)(1) == 13

describe "invoke", ->
  it "calls its argument", ->
    x = 0
    poke = -> x = 10
    functions.invoke(poke)
    assert.equal x, 10

  it "calls its argument with the rest of its arguments", ->
    x = 0
    poke = (nums...) -> nums.forEach (num) -> x += num
    functions.invoke(poke, 1, 2, 3)
    assert.equal x, 6

  it "preserves context", ->
    obj = { x: 0 }
    poke = (nums...) -> nums.forEach (num) => @x += num
    functions.invoke.call(obj, poke, 1, 2, 3)
    assert.equal obj.x, 6

  it "returns the function's return value", ->
    getTen = -> 10
    assert.equal functions.invoke(getTen), 10
