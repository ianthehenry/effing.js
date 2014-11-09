cherry = require 'effing/cherry'
{ assert } = require 'chai'

describe "cherry", ->
  it "returns first or later when there's no both", ->
    fn = cherry
      first: -> 10
      later: -> 20
    assert fn() == 10
    assert fn() == 20
    assert fn() == 20

  it "returns both when it exists", ->
    fn = cherry
      first: -> 10
      later: -> 20
      both: -> 30
    assert fn() == 30
    assert fn() == 30
    assert fn() == 30

  it "returns beforeBoth if it's the only thing specified", ->
    fn = cherry
      beforeBoth: -> 5
    assert fn() == 5
    assert fn() == 5
    assert fn() == 5

  it "only runs the first argument once", ->
    x = 0
    fn = cherry first: -> x++
    fn()
    fn()
    fn()
    assert x == 1

  it "only runs the later argument after the first invocation", ->
    x = 0
    fn = cherry later: -> x++
    fn()
    assert x == 0
    fn()
    assert x == 1
    fn()
    assert x == 2

  it "preserves context", ->
    obj =
      foo: 10

    fn = cherry
      first: -> @foo + 1
      later: -> @foo + 2

    assert fn.call(obj) == 11
    assert fn.call(obj) == 12

  it "allows functionoids", ->
    obj =
      foo: 10

    stranger =
      foo: 30

    fn = cherry
      first: [stranger, (-> @foo + 1)]
      later: -> @foo + 2

    assert fn.call(obj) == 31
    assert fn.call(obj) == 12
