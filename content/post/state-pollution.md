+++
date = "2016-10-10T20:39:45-07:00"
draft = false
tags = []
title = "state pollution"

+++


## Introduction

I'd like to share an method I've developed on how to judge a code. This method
uses a metric that I named *state pollution*.

Note: I am not well versed in academic Computer Science nomenclature and just
trying to be precise in my explanation. Be aware that I might be wrong
somewhere and please feel free to correct me if I'm naming something wrong or
misusing concepts. Maybe someone already described something like that (or
better). Please refer me right places if it the case.

First, I use *state* as a synonym of *entropy* or *amount of information*.

*State pollution* of a fragment of a code is an amount of *aggregate visible state*
that fragment adds to the whole code.

*Aggregate visible state* is sum of *visible state* of every executable line of
the code.

*Visible state* of a piece/line of code is the amount of *state* this code can
access (*readable visible state*) or modify (*writeable visible state*).

The state is measured in bits. Eg. boolean variable can be only in two states:
`true` or `false`. This is 1 bit of information. A C-language `char` has 256
possible values, which is 8 bits.

The following Rust Hello World example has 0-bits of *aggregate visible state*.

```rust
fn main() {
    println!("Hello world!");
}
```

The above code has only one effective line of code: `println!(...)` and that line has no variables to access or modify.

Now let's say we're going to add a pointless mutable `8-bit` variable:

```rust
fn main() {
    let mut x = 0u8;
    println!("Hello world!");
}
```

This new line makes it potentially possible for `println!(...)` to print a text
dependent on it's value. So the *aggregate visible state* of the code is now `8-bits`, and
the *state pollution* introduced by new line is `8-bits`.

Not that if `mut` keyword was removed, `println!(...)` could potentially print
`x`, but not modify it (as variables are immutable by default in Rust). That
would cause *aggregate writeable visible state* to stay equal to 0, increasing
only *readable visible state*.

Note: this whole *entropy* calculation is not meant to be precise. It is to be thought of
as [Big O Notation][big-o]. It's the magnitude that is important, not the exact values! To mimic `O(...)`
I'm going to use similar `P(...)` where *P* stands for *pollution*.

[big-o]: https://en.wikipedia.org/wiki/Big_O_notation

I hope the concept is clear now. Now let's get to while it's useful. I find
*state pollution* metric to be generalization of many other more-specific ways
to judge the code, and corresponding to "good practices" and judgments about the
code that people develop with experience.

## Why is using enumerator better than an integer

Let's compare:

```rust
enum State {
    Open,
    Connected,
    Errored
}

state : State;
```

vs

```rust
state : uint;
```

`state` that is an enumerator have only 3 possible values (entropy = 1.5 bits). `state` that is just an integer,
has a lot more possible values, thus introducing more *state pollution*.


## Why are local values preferable over globals

Most programmers would agree that avoiding global values in any code is a good
practice. Using *state pollution* metric one could say that, a global variable
has a `P(n*e)` where `n` is number of lines of the whole code and `e` is a entropy of the
variable itself (1-bit for boolean, 8-bit for C-language char, etc.). In contrast
local variable has a `P(m*e)` where `m` is total number of lines of one
function.  As `n >= m` using local variables instead of global is minimizing
*aggregate visible state pollution*

Natural language explanation simple: every global variable in your code makes
every line of your code potentially do something different depending on the value
of that variable.

## Why is static typing preferable over dynamic typing?

In statically-typed languages `bool` can have only two values. That's enforced.
In dynamically-typed, every variable can potentially have any value of any
type. Variables in dynamically-typed languages introduce more *state
pollution*. Obviously code written in dynamically-typed language variables
doesn't always abuse that, but as a possibility - it's always there, in every
variable. Maybe by mistake, maybe on purpose, and change to the code could
introduce a new state. So *state pollution* is there, maybe just discounted a
little.

## Why are immutable variables better than mutable

The mutable state increases both *writeable* and *readable visible pollution*,
immutable only the later. With immutable state any code can potentially
experience different behavior depending on the state, but at least can't change
the behavior of other places that are polluted with the same state.

## Why is encapsulation and abstraction good

Limiting visibility of the state using eg. Go `interfaces` or Rust `traits`, or
just field and method visibility settings does not completely remove the state,
but wraps it in a surface that limits it's effective pollution: the code exposed to
encapsulated or abstracted state can't directly interfere with it.

## Why is functional code preferable over imperative

By nature functional code limits the state pollution. Eg. pure virtual function
can only use it's arguments, so that arguments are the only state that pollutes
the function code.
