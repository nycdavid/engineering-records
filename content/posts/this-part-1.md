---
title: "this in nodejs and the browser, Part 1: In the Global Scope"
date: 2018-01-02
tags: ["javascript", "this", "nodejs", "browser"]
draft: false
meta_description: "In this post, we're going to take a look at what different values the keyword this takes on in Javascript. This post is the first in a series of posts designed to demystify this and how to use it in javascript functions."
---

# What is `this` in Javascript?
The keyword `this` is the subject of much confusion in Javascript, primarily
because its value can (and often does) change according to the context that it's
evaluated in.

Put simply, `this` is a way to provide a function with some context during runtime.
Its value is entirely dependent on where and when the __function containing it is
run__.

Todays article will be the first in a series of articles diving into the value
of `this` examined in several different contexts:

* The nodejs REPL
* Chrome dev tools console
* From within an object
* From within a function

---

# nodejs REPL and Chrome Dev Tools
We look at these two environments first because of their inherent platform
differences. Although they share a common language (Javascript), the __global
objects__ available to each runtime is inherently different because one is
__server-side__ while the other is __client-side__.

## Chrome Development Tools
In the Chrome console, examining `this` without executing it in the context of a
function or object will show you that its value is __the window object__.

![Demonstrating window and this equality](https://i.imgur.com/fkGmApr.png)

## nodejs REPL
Similarly, in a nodejs console, the value of `this` evaluated outside of any
context is the nodejs `global` object.

![this in nodejs](https://i.imgur.com/uplbzkQ.png)

`this` outside of a function or object context is quite straightforward: it
is usually going to be the __global object__ in non strict mode and `undefined`
in strict mode.

---

In order to keep this cognitive load light (which I believe to be crucial when
learning), I'm going to make a concerted effort to keep these blog posts small.

In the [next post in the series](/posts/this-part-2) we'll dive into what `this`
looks like within different types of functions.

## An aside about strict mode...

But before we dive into the next post, I'd like to take a moment to say a few
words about __strict mode__ in Javascript.

Strict mode is a preference that can be activated both in the browser and in
the nodejs runtime to put stricter rules on certain semantics in JS code.

For instance, strict mode will throw an exception when attempting to set an
undefined variable and also prevent `this` from taking on an implicit value
when it normally would in a non-strict environment.

It's sometimes preferred because it forces the reduction of ambiguity in certain
parts of your code, thus reducing the amount of tricky errors that take you off
track via hard-to-trace bugs.

Again, it is 100% a matter of preference, and, when in doubt, you should defer
to the standard that is used by the project you're working on.

You can read more about it [here, at MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
