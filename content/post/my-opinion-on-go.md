+++
date = "2016-09-27T18:12:41-07:00"
tags = ["go", "opinion", "rant"]
title = "My opinion on Go"
+++

## TL;DR

The biggest strength of Go, IMO, was the FAD created by the fact that it is
"backed by Google". That gave Go immediate traction, and bootstrapped a
decently sized ecosystem. Everybody know about it, and have somewhat positive
attitude thinking "it's simple, fast, and easy to learn".

I enjoy (Crude but still) static typing, compiling to native
code, and most of all: native-green thread support make Go quite productive for
server side code. You just have to get used to many workarounds for lack of
generics, remember about avoid all the [Go landmines][landmines] and don't mind poor
expressiveness.

My favourite thing about Go, is that it produces static, native binaries.
Unlike software written in Python, using software writing in Go is always
painless.

However overall, Go is poorly designed language full of painful archaisms. It
ignores multiple great ideas from programming languages research and other PL
experiences.

["Go's simplicity is syntactic. The complexity is in semantics and runtime
behavior."](https://news.ycombinator.com/item?id=12525949)

Every time I write code in Go, I feel deeply disappointed.

## Reading material

I think the best description of Go's problems was [Why Go Is Not Good](http://yager.io/programming/go.html).

Also interesting: [I Love Go; I Hate Go](http://dtrace.org/blogs/ahl/2016/08/02/i-love-go-i-hate-go/)

[landmines]: https://gist.github.com/lavalamp/4bd23295a9f32706a48f


## More on my experiences with Go 

While I was following Go programming language since it's announcement and even
did some learning and toying with it, only recently I had opportunity to try Go
in real projects. For the last couple of months I've been working a lot with
Go, and below is why I think Go is simply a bad programming language.

### Nil

`nil`/`null` should not exists in any recent programming language.

`nil` keeps being the biggest source of frustration when working with code
written in Go. `nil` handling is inconsistent too with sometimes `nil` being OK
to use, and sometimes not so much.

### No sane error handling

```go
o1, err := DoSomething1()
if err != nil {
    return
}
defer Cleanup(o1)

o2, err := o2.DoSomething2()
if err != nil {
    return
}
defer Cleanup2(o2)

…

oN, err := oN-1.DoSomethingN()
if err != nil {
    return
}
defer CleanupN(oN)
```

compare the above with corresponding Rust code:

```rust
let o1 = try!(DoSomething1());
let o2 = try!(o1.DoSomething2());
…
let oN = try!(oN-1.DoSomethingN());
```

or 

```rust
DoSomething1()
   .and_then(|o1| o1.DoSomething2())
   .and_then(|o2| o2.DoSomething2())
   …
   .and_then(|oN| oN.DoSomethingN())
```

You might ask, where are the cleanup calls. Well, because Rust has guaranteed,
predictable destructors, you don't need cleanup calls 99% of the time! Files
and sockets will be closed, http connections ended (or returned to the pool) etc.

[Mildly-satisfying workarounds are given](https://blog.golang.org/error-handling-and-go)

### Lack of generics

It seems to me lack of generic support is the root cause of all other problems.

Go has `nil` because without some form of generics, having a `Option` is not
possible.

Go has poor error handling, as something like Rust's `Result` can not be used
without generics.

Go has no proper collections, and you weird `make` invocations are required
because it lacks generics.

### Annoyingness

I fiddle with the code to try something out, I get an error that something is
not used anymore. I have to remove the `import` to make the compiler happy.
Then add it again.

Why it can't be just a warning? Why is it *that* important for all the
`imports` to really be used?

Or compiler errors because `{` is on a newline. Madness.

Go compiler is happy when I don't check errors returned by a function (maybe by
mistake), and I have to use `go vet` and `golint` to ensure they are no real
issues, but it just won't let me be due to irrelevant details.


### Small things

How do you decrement an atomic in Go?

```go
AddUint32(&x, ^uint32(c-1))
```

That's how. Easy to read, and self-explaining.
https://golang.org/pkg/sync/atomic/ . I mean... come on. It took similar time
to write the comment explaining how to decrement, as it would take to write a
much needed function that would just do it!

### Community doesn't like me

Couple of times I ventured into Go community gathering places, looking for
advise on how to deal with some of the problems I was having. I don't know if
it's me, or the fact that I was referring to mechanisms from other languages,
that Go simply lacks, but every time I got rather hostile responses in tones of
"one true way of Go".
