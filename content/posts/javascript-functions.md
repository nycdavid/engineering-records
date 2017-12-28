---
title: "Javascript Functions"
date: 2017-12-28
tags: ["javascript", "functions", "call", "apply", "bind", "this"]
draft: false
---

# Functions in Javascript
## An analogy
Usually, when functions are taught in school or other learning material, students
are taught to think of them as "black boxes" that perform an action on given
inputs and return the resulting outputs.

To expand on that analogy further, a __function__ of any kind can be thought of
as a __machine__ that has __one point of entry__ and __one point of exit__.

For instance, let's say our "function" is a juicing machine:

* The *action performed* is grinding the fruit into juice
* The *input* is the mouth where apples and oranges are inserted
* The *output* is the spout where the resulting juice pours into the cup

![Javascript functions are like machines](/img/javascript-functions/juicer.jpg)

## Functions are first-class
Functions are *so* important in Javascript that they're considered __first class__,
meaning they're treated like any other variable. This means they
can be stored in a variable and passed into other functions.

This would be analogous to taking our juicer from the previous example (which itself
is a function) and placing it in the *dishwasher*, another function.

The ability to do this is important when we realize that Javascript executes
some functions __asynchronously__, meaning that a function will begin and be left
alone to do its work while the rest of the program executes.

Although async functions are outside of the scope of this article, the ability to pass
a function in to another one is crucial because, if an asynchronous function knows
about another function during it's execution, it has the ability to execute
that function when its own execution is complete.

One way to provide awareness to a function of the existence of another function
is by __passing it in as a parameter__, a feature provided by __first class
functions__.

[TODO image]

---

# Javascript Function Concept #1: `this`

---

# Javascript Function Concept #2: `bind`

---

# Javascript Function Concept #3: `call/apply`
