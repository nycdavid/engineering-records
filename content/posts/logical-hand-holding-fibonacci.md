---
title: "Logical hand holding: Time complexity of a Fibonacci function"
date: 2018-08-10
tags: ["time complexity", "fibonacci", "computer science"]
draft: false
meta_description: "In this post we take a look at analyzing the time complexity
of a function that computes the nth number in a Fibonacci sequence"
---

# Why logical hand holding?

The main motivation behind these blog posts will be to serve as records of
any logical break throughs that I might have while working my way through the
curriculum of the Computer Science Master's program at Georgia Tech.

I've found that, until I've really mastered the concept, the breakthroughs
and "Aha!" moments I have can be fleeting, thus the need for a record like
this.

### Recursive function to calculate the nth Fibonacci number

```go
package main

func fibonacci(nth int) {
  if nth == 0 {
    return 0 
  } 
  if nth == 1 {
    return 1
  }
  return fibonacci(nth - 1) + fibonacci(nth - 2)
}
```

### Time complexity of each part

Breaking up the function into distinct parts yields 2 sections, depending on 
what the value of `nth` is.

#### Part 1: the `if` statements

```go
if nth == 0 {
  return 0
}
if nth == 1 {
  return 1
}
```

* __Statement__: The above runs in \\(O(1)\\) (constant) time. 
* __Justification__: Regardless of the input size, whatever is in 
the `if` statement will only be invoked when `nth` is either 
`0` or `1` and it is simply returning a value, hence \\(O(1)\\).

#### Part 2: The recursive invocation

```go
return fibonacci(nth - 1) + fibonacci(nth - 2)
```
