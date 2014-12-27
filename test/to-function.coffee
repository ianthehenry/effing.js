f = require 'effing/to-function'
{ assert } = require 'chai'

describe "f", ->
  it "passes through functions unchanged", ->
    fn = ->
    assert f(fn) == fn

  it "partially applies functions", ->
    add = (a, b) -> a + b
    addTen = f(add, 10)
    assert addTen(20)

  it "produces a no-op when invoked with no arguments", ->
    f()

  it "converts null to a noop", ->
    f(null)

  it "converts undefined to a noop", ->
    f(undefined)

  it "doesn't take kindly to empty arrays", ->
    assert.throws -> f([])

  it "doesn't take kindly to objects with no methods", ->
    assert.throws -> f({})

  it "creates bound functions", ->
    assert f({foo: 10}, -> @foo)() == 10

  it "partially applies bound functions", ->
    assert f({foo: 10}, ((a, b) -> a + @foo + b), 1)(2) == 13

  it "creates bound functions by method lookup", ->
    obj =
      foo: 10
      getFoo: -> @foo
    assert f(obj, 'getFoo')() == 10

  it "looks up methods at creation time", ->
    obj =
      foo: 10
      getFoo: -> @foo
    boundFn = f(obj, 'getFoo')
    obj.getFoo = -> throw new Error "don't invoke me!"
    assert boundFn() == 10
