---
title: "this in nodejs and the browser, Part 2: Inside of Function Declarations"
date: 2018-01-02
tags: ["javascript", "this", "nodejs", "browser"]
draft: true
---

# `this` within a function declaration
In this post, we'll talk about the various values that `this` can take on when
declared inside of a function declaration in the different cases below and, it's
worth noting that we'll be looking at these cases while the Javascript engine
is set to __strict mode__.

There are 3 different scenarios that are worth exploring while working with `this`
inside of a function:

* A __single function declaration__.
* A __nested function declaration__ where a function is declared within another function.
* An __arrow function declaration__.

## Single function
This would look like the following:

```javascript
function gimmeThis() {
  return this;
}
```

Here's the million dollar question: what would be the return value of the `gimmeThis`
function?

It would be `undefined`!

This is wholly dependent on the decision to use "strict mode" while writing
Javascript. __If we weren't in strict mode__, the value of `this` would have been
implicitly declared to be the outer containing scope, which, in this case would
have been the global scope.

## Function within another function
This scenario can be thought of as somewhat derivative of the above scenario.
It's simpler to reason about as long as you remember that, in strict mode,
the value of `this` within a function becomes `undefined` if not specifically
declared.

```javascript
function() {
  console.log(this);
  (function () {
    console.log(this);
  })()
}
```

NOTE: the 2nd function that's declared within the outer function uses a Javascript
idiom called an __IIFE__ (pronounced "iffy"), or an __immediately invoked function
expression__. You can read more about the IIFE construct [here](https://developer.mozilla.org/en-US/docs/Glossary/IIFE)

## Fat Arrow Function
The scenario above exposed a "sharp edge" that many a Javascript developer has
grappled with in the past when working with the ES5 specification of Javascript:
__functions will lose their knowledge of `this` when nested in another function
declaration__.

This tended to be a fair source of frustration as difficult-to-trace bugs as
its usually something that you have to "just know".

Luckily the ES6/ES2015 specification introduced a construct to specifically
combat this issue: [arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions#Arrow_functions)

---

What __arrow functions__ allow you to do is to "keep the lexical value of `this`"
in the body of the function declaration. What this means is that when you declare
an arrow function, the value of `this` inside of that function will automagically
take on the `this` value from the outside scope in which it was declared.

Let's take a look with an example:

```javascript`
const thisObj = { name: 'School House Rock' };

// without an arrow function
function conjunction() {
  return (function() {
    return this;
  })();
}
conjunction.bind(thisObj)()

// with an arrow function
function conjunction() {
  return (() => {
    return this;
  })()
}
conjunction.bind(thisObj)()
```

Let's see what the first example evaluates to:

![Non-arrow function in the nodejs REPL](https://i.imgur.com/ljKOyxu.png)

And now the second example?

![Arrow function in the nodejs REPL](https://i.imgur.com/v7y2AOk.png)

As is demonstrated in the latter example, an arrow function will allow one to
preserve the value of `this`, even if a function is nested, preventing any
nasty surprises from sneaking up on you later on during the execution of your
program.
