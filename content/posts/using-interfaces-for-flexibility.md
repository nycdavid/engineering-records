---
title: "Using interfaces for flexibility"
date: 2017-11-12
tags: ["go", "interfaces"]
draft: false
---

My first foray into software engineering was with Ruby in 2011, when Rails was
still everyone's (arguably) first choice to build a web application. Times were
good then. Ruby was (and still is) a very forgiving language, one that allows
you to get away with a lot, and does it's best to massage the code that you
write into a production-ready app.

Sometimes this approach causes more problems than it solves, however. Oftentimes
you'll find a function or a method that is written in so specific of a way to
expect one type, like a date or an integer, that it will literally have no idea
what to do when presented with another type of argument. More often than not
this insidious type of tech debt will cause difficult to find bugs that will
cost hours and hours of frustration and productivity.

What to do in such a situation?

## Static Typing

One of the best ways to combat the above issue is by __static typing__. Static
typing requires that we specify all types for all variables, function parameters
and function return values beforehand to the compiler and that we adhere to
these types throughout the life and execution of the program. The Go language is
statically typed (as are many compiled languages like C++ and Java).

Static typing is a wonderful asset to ensure that your program doesn't encounter
any nasty surprises during it's life that may derail an otherwise healthy
application or library. It also ensures that the functions that you write
continue to be used in the way that they were intended, even with numerous
people expanding upon them or including them into code that they've
written.

If you're anything like me though, you'll soon begin to wonder "How can I write
code that *can* account for multiple situations?" Even if your code shouldn't
necessarily be unpredictable, there *are* times where you'd want it to be
__flexible__. This is a trait that, I would think, isn't a farfetched ask of any
codebase or language.

## An example

Enough with explanations though, let's see an example!

How would I write a function that concatenates two arguments together while
adding a `+` character in between them?

If we're talking about two arguments of the `string` type, this is exceedingly
easy. We can use `fmt.Sprintf` and be done with it, can't we?

```go
import (
  "fmt"
)

func concat(arg1 string, arg2 string) string {
  return fmt.Sprintf("%s + %s", arg1, arg2)
}
```

What if we wanted to concat two `int` types together? This is a bit more
complicated because we have to convert the integers to strings prior to
attempting to use them in the call to `Sprintf`, but once we know how to do
that... this, too, is quite simple.

```go
import (
  "fmt"
  "strconv"
)

func concat(arg1 int, arg2 int) string {
  n1 := strconv.Itoa(arg1)
  n2 := strconv.Itoa(arg2)
  return fmt.Sprintf("%s + %s", n1, n2)
}
```

But what if we wanted to allow a mix of `int` and `string` without necessarily
specifying which argument was what? Go won't let us pass an integer in place
of a string and vice versa. Even so, we don't necessarily want to prescribe
in the method signature that everyone who uses our function pass their
arguments in a specific order.

This is precisely where those new to static typing (including me) may have begun
to chafe under it's rigidity.

## Enter Interfaces

> Interfaces, simply explained, allow a type to be defined solely by what
methods the type implements.

Luckily, the creators of Go, in their infinite wisdom, decided to add interfaces
to the language! Interfaces, simply explained, allow a type to be defined solely
by what methods the type implements.

Let's see an example first:

```go
import (
  "fmt"
  "strconv"
)

type operand interface{}

func concat(arg1 operand, arg2 operand) {
  // body of the func
}
```

The most significant bit is the `type operand interface{}`. What we're doing
here is we're defining a type `operand` with an empty interface, which means we
*don't require anything* for a type to implement the `operand` interface.

What this translates to when set as a type for a function argument is that we
can pass *any* type to the above `concat` function and the compiler will
consider that interface implemented (because operand doesn't require anything).

We aren't quite done yet, though. Although we've accounted for the normalizing
of the function parameter, Go's static typing isn't quite satisfied. We can't
simply declare an empty interface and then do whatever we want with it once
we have it. That would be a loophole that completely nullifies any of the
benefits of the compiler's attempts at type safety.

What, then, does the body of the `concat` function look like?

## Type assertions

Although we've gotten the arguments into the function via an acceptable form,
we can't quite do what we want with the `operand` type just yet. If you attempt
to pass them to any calls to `fmt.Sprintf` you'll have the compiler complain
that you need to perform what's known as a __type assertion__.

A type assertion is Go's way of ensuring type safety even when using something
abstract/flexible like an interface. It is, effectively, a way to coerce an
interface into one of Go's native types, thereby allowing us to start using
the type in situations that require it. Here's what that looks like:

```go
import (
  "fmt"
  "strconv"
)

type operand interface{}

func concat(arg1 operand, arg2 operand) {
  switch arg1.(type) {
  case string:
    o1 := arg1.(string)
    // do something with string argument
  case int:
    o1 := arg1.(int)
    // do something with int argument
  default:
    // something
  }
}
```

The switch statement above is a special type of switch in Go, called a __type
switch__. It allows us to attempt multiple type assertions in series so that
we can test which type the interface successfully coerces into. Once it falls
into a case, we can execute some type-specific code.

Let's use this type switch to finally complete our `concat` function:

```go
import (
  "fmt"
  "strconv"
  "bytes"
)

type operand interface{}

func concat(arg1 operand, arg2 operand) {
  var o1 string
  var o2 string
  switch arg1.(type) {
  case string:
    o1 = arg1.(string)
  case int:  
    o1 = strconv.Itoa(arg1.(int))
  default:
    // something
  }
  switch arg2.(type) {
  case string:
    o2 = arg2.(string)
  case int:
    o2 = strconv.Itoa(arg2.(int))
  default:
  }
  str := fmt.Sprintf("%s + %s", o1, o2)
  fmt.Println(str)
}
```

Now we can see that we're able to do a `fmt.Sprintf` because our arguments have
all been normalized into strings that we can interpolate and print out with
`fmt.Println`.

---

Hopefully that was a gentle introduction into Go's interfaces, expect plenty
more posts on the power and expressiveness of Go.
