overloaded = require 'effing/overloaded'
{ assert } = require 'chai'

describe "overloaded", ->
  it "uses argument length to switch", ->
    val = 0
    fn = overloaded
      0: -> val = 10
      1: -> val = 20
    fn()
    assert val == 10
    fn('foo')
    assert val == 20

  it "throws an error on too few arguments", ->
    fn = overloaded
      2: ->
    assert.throws -> fn('foo')

  it "throws an error if passed no values", ->
    assert.throws -> overloaded {}

  it "throws an error if passed no arguments", ->
    assert.throws -> overloaded()

  it "throws an error if passed a non-numeric key", ->
    assert.throws -> overloaded {'foo': (->), '0': (->)}

  it "allows any JS-formatted numeric key", ->
    fn = overloaded
      '0x1': -> 1
      '20e-1': -> 2
    assert fn('foo') == 1
    assert fn('foo', 'bar') == 2

  it "allows too many arguments", ->
    fn = overloaded
      0: -> 0
      1: -> 1
      5: -> 5
      6: -> 6
    assert fn('one', 'two', 'three') == 1
    assert fn('one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight') == 6

  it "allows functionoids", ->
    addTen = (x) -> x + 10
    fn = overloaded
      0: [addTen, 20]
    assert fn() == 30
