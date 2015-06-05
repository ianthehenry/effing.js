[![Build Status](https://travis-ci.org/ianthehenry/effing.svg)](https://travis-ci.org/ianthehenry/effing)

# effing.js

Some handy function functions for JavaScript, minus the docs and examples and such.

- easy partial application: `f(func, arg)`
- easy function binding: `f(obj, method)`
- easy both at the same time: `f(obj, method, arg)`
- function equivalents for operators: `[1, 2, 3].reduce(f.add)`
- partial application for operators: `[-3, 4, 2].filter(f.gt(0))`

# API

There are three big ideas here:

- *Function Conversion*: `effing` exposes a function, `f`, which converts various things into functions.
- *Helpers*: the function has helper functions attached to it, such as `f.compose` and `f.const`.
- *Lifted Operators*: it also has function versions of built-in JS operators, such as `f.add` and `f.gte`.

# Function conversion

`effing.js` exposes a function, generally referred to as `f`, which performs the following transformations:

- `f()`, `f(null)`, and `f(undefined)` return a no-op function
- `f(fn, args...)` returns a partially applied function
- `f(context, method, args...)` returns a partially applied function with a bound context
- `f(context, 'methodName', args...)` returns a partially applied function with a bound context by looking up the specified key on the context

Note that the context-binding forms do not allow `Function`s to be passed as the context. `effing.js` can't read your mind.

# Helper functions

### `id :: Any -> Any`

The identity function.

### `compose :: (Function, Function) -> Function`

Function composition: `f.compose(a, b) = a ∘ b`.

### `invoke :: (Function, Any...) -> Function`

A function that lifts function application. Instead of:

```javascript
[getName, getAddress].map(function(f) { return f(); });
```

You can write:

```javascript
[getName, getAddress].map(f.invoke)
```

It's like `f.method('call')`, except that it preserves the context it's invoked with.

### `unpack :: Function -> Function`

Given a function, `unpack` returns a function that expects an array and invokes the inner function with the array expanded into arguments, using `apply`. The context is preserved.

```javascript
var addPair = f.unpack(function(a, b) { a + b });
[[1, 2], [3, 4]].map(addPair) // 3, 7
```

### `guard :: (Function, Predicate, Any?) -> Function`

Given a function and a predicate (a function that returns `true` or `false`), `guard` returns a function that will only invoke the "body" function when the predicate passes. The predicate and function are invoked with the arguments and context of the outer function. You can supply an optional third value to use as the return value when the predicate fails; the default is `undefined`.

### `const :: Any -> Function`

Given a value, this returns a function that always returns that value.

### `once :: (Function, String?) -> Function`

Given a function, returns a function that will throw an error if it's invoked more than once. You can optionally supply a useful error message to throw with when this happens.

### `concat :: Function... -> Function`

Given a list of functions, returns a function that invokes each of them in order with the same arguments and context.

### `choke :: (Number, Function) -> Function`

Given a number and a function, returns a function that will call the provided function with, at maximum, the specified number of arguments.

For example:

    f.choke(1, console.log)("hello", "world")

Will only print out `hello`, because it is "choked" to a single argument.

This is useful for times when JavaScript passes additional arguments that you don't want. For example, you can use it to avoid a classic JS gotcha:

    var nums = ['10', '20', '30', '40', '50', '60', '70', '80', '90', '100'];
    nums.map(parseInt) // [10, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 81]
    nums.map(f.choke(parseInt, 1)) // [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]

Note that you should still explicitly specify the radix, to avoid [the *other* `parseInt` gotcha](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt#Octal_interpretations_with_no_radix).

### `negate :: Function -> Function`

Given a function, returns a new function that negates the return value of its inner function.

### `overloaded :: Object -> Function`

Given a map of *numbers of arguments* to *implementations*, this returns a new function that looks up the appropriate implementation based on the number of arguments provided and invokes it. For example:

```javascript
f.overloaded({
    0: function() {
        throw new Error("You must supply at least one argument");
    },
    1: function() {
        console.log("invoked with 1 or 2 arguments");
    },
    3: function() {
        console.log("invoked with 3 or more arguments");
    }
})(1, 2, 3, 4);
```

### `managed`

`managed` takes a normal function and returns a function that cannot be invoked directly but can only be *leased*. Only the most recently leased function will *do anything* when invoked; leasing invalidates the previously leased function and turns it into a no-op.

Here is a very weird nonsense example that nonetheless demonstrates the behavior:

```javascript
var fn = f.managed(function() {
    throw new Error("Don't invoke me!");
});

var first = fn.lease();
var second = fn.lease();

first(); // nothing happens, because leasing
         // `second` invalidated first

second(); // but second is still valid, so
          // this throws an error
```

The intention of `managed` is to ensure that callbacks don't fire in the wrong order, when doing something like search-as-you-type loading.

### `curried :: (Number?, Function) -> Function`

This function returns a curried version of another function, which is a function that will continuously return partially applied versions of itself until you supply it "enough" arguments. See [the tests](https://github.com/ianthehenry/effing/blob/master/test/curried.coffee).

You can optionally pass it the number of arguments to expect. If you omit this argument, it will use [`fn.length`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/length) to figure out the expected number of arguments. It is recommended that you always specify this explicitly, *especially* if you are not passing in an anonymous function.

### `prime`

This returns a function that behaves differently the first time it's invoked from subsequent invocations. It takes a map of arguments, which should all be functions, and returns a function that will invoke some of the functions you passed it whenever it's invoked.

The arguments you can pass are `first`, `after`, `both`, `beforeBoth`, and `afterBoth` (`both` and `afterBoth` are interchangeable). The behavior is hopefully intuitive. `beforeBoth` and `afterBoth`/`both` are always invoked, whereas `first` is only invoked once and `after` is invoked on each subsequent call.

```javascript
// a render function that inserts itself into
// the DOM the first time it's called
var render = f.prime({
    first: function() {
        parentEl.appendChild(this.el);
    },
    both: function() {
        this.el.html = "...";
    }
});
```

The inner functions receive all the arguments passed to the outer functions and are invoked with the same context. The return value is equal to the return value of the most recent function invoked: so if you supply `beforeBoth` and `first`, the return value your `first` function will be return on the first invocation and `beforeBoth` on subsequent invocations.

## Object-related helpers

### `get :: String -> Object -> Function`

`get` is a curried function that lifts expressions of the form `obj[key]`. It can be invoked directly, like `f.get('foo', { foo: 123 })`, but it is more useful when inokved with one argument: `people.map(f.get('name'))`, where it will return a "function that gets."

### `lookup :: Object -> String -> Function`

The same as `get` with the argument order reversed. Can be used to create "lookup functions," so we could write [Mustache.js's `escapeHtml`](https://github.com/janl/mustache.js/blob/2ba7481d41e356869dc2db695ccc4a0cf3ce38cd/mustache.js#L52) function as:

```javascript
var escapeHtml = function (string) {
    return String(string).replace(/[&<>"'\/]/g, f.lookup(entityMap));
}
```

### `set :: String -> Object -> Any -> Function`

`set` is a curried function that lifts expressions of the form `obj[key] = val`.

### `method :: (String, Any...) -> Function`

`method` is a curried function that lifts expressions of the form `obj[key](args...)`. Examples:

```javascript
people.forEach(f.method('printName'));
people.map(f.method('calculateLifeExpectancy', 2015));
```

The actual function signature is probably the best way to explain how it works:

```coffeescript
method: (methodName, args...) -> (obj, moreArgs...) ->
```

You invoke it with the name of a "method" and an optional list of arguments. It returns a function that expects an object followed by an optional list of *additional* arguments. When you invoke the returned function, it looks up the method on the object and invokes it with all the supplied arguments concatenated together (and the context set to the object itself).

# Lifted Operators

`effing.js` exposes function equivalents of many of JavaScript's operators, for ease of composition.

## Logical operators

operator | name
---------|-----
`&&`     | `and`
`||`     | `or`
`!`      | `not`

## Comparison operators

operator | name
---------|-----
`<`      | `lt`
`>`      | `gt`
`<=`     | `lte`
`>=`     | `gte`
`===`    | `eq`
`!==`    | `neq`

## Numeric operators

operator | name        | alias
---------|-------------|------
`+`      | `add`       |
`-`      | `subtract`  | `sub`
`*`      | `multiply`  | `mult`
`/`      | `divide`    | `div`
`%`      | `remainder` | `rem`
`-`      | `negate`    | `neg`

`effing.js` also has some numeric operators that JavaScript doesn't have:

name        | alias  | description
------------|--------|------------
`modulo`    | `mod`  | Like JavaScript's remainder operator, but will never produce a negative value.
`intDivide` | `idiv` | Floor division.

## Partial application for binary operators

Haskell has a very nice syntax for partial application of binary operators:

```haskell
isMinor = (< 18)
```

`effing.js` exposes something similar in its lifted operators:

```javascript
var isMinor = f.lt(18);
```

When you invoke any of the binary operator functions with a single argument, it will always fill in the *right side* of the operator. To fill in the left argument, you can use normal partial application:

```javascript
var probabilityNot = f(f.sub, 1);
probabilityNot(0.75) # 0.25
```
