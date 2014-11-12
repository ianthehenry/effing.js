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
