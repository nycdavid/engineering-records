---
title: "this in nodejs and the browser, Part 2: bind, call & apply"
date: 2018-01-02
tags: ["javascript", "this", "nodejs", "browser"]
draft: false
---

# Functions and `this`
In the [previous post](/posts/this-part-1), we learned that `this` in the global
is simply the global scope itself. This, of course, isn't of much use to us and
is simply a starting point.

The real essence of Javascript arises from being able to evaluate and return
`this` in a function setting. The function is our workhorse and so being able
to do different things depending on the value of `this` is

In this post, we're going to explore 2 different ways in which you can change
the value of `this` at runtime to whatever you want:

1. The `bind` method
2. The `call/apply` method

---

## Function.prototype.bind
`bind` is a method that can be called on any function and accepts an object as
its first argument and a list of additional arguments.

What `bind` allows you to do is the following:

* Create a function that sets the `this` value to whatever object you pass in
* Prepend additional arguments to the arguments already listed out by the
original function definition.
