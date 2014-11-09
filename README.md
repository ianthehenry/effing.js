[![Build Status](https://travis-ci.org/ianthehenry/effing.svg)](https://travis-ci.org/ianthehenry/effing)

# effing.js

Some handy function functions for JavaScript, minus the docs and examples and such.

# Functionoids

The following things are coerced into functions by `effing.js`:

- `null` becomes a no-op function
- `undefined` becomes a no-op function
- `[fn, args...]` returns a partially applied function
- `[context, method, args...]` returns a partially applied function with a bound context
- `[context, 'methodName', args...]` looks up the function on the context and returns it bound to the context with partially applied arguments

Anywhere effing.js expects a function argument, it will be happy with a functionoid instead.

The `[context, ...]` functionoids don't allow `Function`s to be used as contexts. `effing.js` can't read your mind.

# Functionoid conversion

`effing.js` exports a function, usually called `f`, that will convert functionoids into normal functions.

When called with one argument, it follows the rules above. When called with no arguments, it returns a no-op function. When called with more than one argument, it behaves as if it were invoked with the arguments in a list.

So `f(fn, arg)` produces a partially applied function, for example, as if you had called `f([fn, arg])`.

# Operators

`effing.js` creates functions for many operators in JavaScript.

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

So you can write `f.add(10, 5)`. But you proabably wouldn't write that! You're far more likely to write something like this:

    [1, 2, 3, 4].reduce f.add

Or like this:

    [1, 2, 3, 4, 5].filter f.lt(3)

But how does that work?

# Partially applied binary operators

In Haskell you can say:

    isMinor = (< 18)

In f'ing JavaScript, you have to say:

    var isMinor = f.lt(18);

When you invoke any of the binary operator functions with a single argument, it will alaways fill in the *right side* of the operator. To fill in the left argument, you can use normal functionoid partial application: `f(f.lt, 18)`.
