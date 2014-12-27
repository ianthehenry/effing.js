[![Build Status](https://travis-ci.org/ianthehenry/effing.svg)](https://travis-ci.org/ianthehenry/effing)

# effing.js

Some handy function functions for JavaScript, minus the docs and examples and such.

- easy partial application: `f(func, arg)`
- easy function binding: `f(obj, method)`
- easy both at the same time: `f(obj, method, arg)`
- function equivalents for operators: `[1, 2, 3].reduce(f.add)`
- partial application for operators: `[-3, 4, 2].filter(f.gt(0))`

# Function conversion

`effing.js` exposes a function, generally referred to as `f`, which performs the following transformations:

- `f()`, `f(null)`, and `f(undefined)` return a no-op function
- `f(fn, args...)` returns a partially applied function
- `f(context, method, args...)` returns a partially applied function with a bound context
- `f(context, 'methodName', args...)` returns a partially applied function with a bound context by looking up the specified key on the context

Note that the context-binding forms do not allow `Function`s to be passed as the context. `effing.js` can't read your mind.

# Operators

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

In Haskell you can say:

    isMinor = (< 18)

In f'ing JavaScript, you have to say:

    var isMinor = f.lt(18);

When you invoke any of the binary operator functions with a single argument, it will always fill in the *right side* of the operator. To fill in the left argument, you can use normal functionoid partial application:

    var probabilityNot = f(f.sub, 1);
    probabilityNot(0.75) # 0.25
