curried = require 'effing/curried'
{ assert } = require 'chai'

describe "curried", ->
  it "uses fn.length for expected parameters", ->
    fn = (a, b, c) -> 10
    assert curried(fn)(1)(2, 3) == 10

  it "allows an explicit length", ->
    fn = (a, b, c) -> 10
    assert curried(fn, 4)(1)(2, 3)(5) == 10

  it "invokes the underlying function when it reaches the right number of arguments", ->
    assert curried(Math.max, 2)(1, 2) == 2
    assert curried(Math.max, 2)(1)(2) == 2

  it "returns curried functions until it reaches the right number of arguments", ->
    assert curried(Math.max, 5)(1)(2, 3)(4)(5) == 5

  it "allows more arguments than specified", ->
    assert curried(Math.max, 2)(1)(2, 3, 4, 5) == 5
