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
  it "throws an error on illegal overload", ->
    fn = overloaded
      0: ->
    assert.throws -> fn('foo')
