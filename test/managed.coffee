managed = require 'effing/managed'
{ assert } = require 'chai'

describe "managed", ->
  it "cannot be invoked directly", ->
    assert.throws -> managed(->)()

  it "can produce leased functions", ->
    x = 0
    managedFn = managed(-> x++)
    first = managedFn.lease()
    assert x == 0
    first()
    assert x == 1

  it "only allows the latest leased function to run", ->
    x = 0
    managedFn = managed(-> x++)
    first = managedFn.lease()
    assert x == 0
    second = managedFn.lease()
    first()
    assert x == 0
    second()
    assert x == 1

  it "allows the latest function to run multiple times", ->
    x = 0
    managedFn = managed(-> x++)
    first = managedFn.lease()
    assert x == 0
    first()
    assert x == 1
    first()
    assert x == 2
    second = managedFn.lease()
    first()
    assert x == 2
    second()
    assert x == 3
