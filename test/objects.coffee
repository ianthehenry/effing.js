objects = require 'effing/objects'
{ assert } = require 'chai'

describe "objects.get", ->
  it "looks up a key on an object", ->
    assert objects.get('name', { name: "John" }) == "John"

  it "can be partially applied", ->
    getName = objects.get 'name'
    assert getName(name: "Mary") == "Mary"

describe "objects.set", ->
  it "sets a key on an object", ->
    person = {}
    objects.set('name', person, "John")
    assert person.name == "John"

  it "allows the key to be partially applied", ->
    person = {}
    setName = objects.set('name')
    setName(person, "Mary")
    assert person.name == "Mary"

  it "allows the object to be partially applied", ->
    person = {}
    setPersonName = objects.set('name', person)
    setPersonName("John")
    assert person.name == "John"

  it "returns the value that it sets", ->
    person = {}
    assert objects.set('name', person, "John") == "John"

describe "objects.method", ->
  it "invokes a method on an object", ->
    assert objects.method('foo', { foo: -> 5 }) == 5

  it "preserves the context", ->
    person =
      name: "John"
      getName: -> @name
    assert objects.method('getName', person) == "John"

  it "forwards arguments", ->
    person =
      age: 18
      ageInTheFuture: (years) -> @age + years
    assert objects.method('ageInTheFuture', person, 10) == 28

  it "allows partial application of the method name", ->
    person =
      age: 18
      getAge: -> @age

    ageGetter = objects.method('getAge')
    assert ageGetter(person) == 18

  it "forwards arguments after being partially applied", ->
    person =
      age: 18
      addAge: (x) -> @age + x

    ageAdder = objects.method('addAge')
    assert ageAdder(person, 10) == 28
