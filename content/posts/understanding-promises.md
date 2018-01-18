---
title: "Understanding Promises"
date: 2018-01-22
tags: ["javascript", "promises"]
draft: false
meta_description: "In this article, we'll take a high-level look at Javascript promises and how they ease the nested 'callback hell' that makes life difficult for programmers. We'll also look at the syntax and mechanics of writing your own promises and how you can convert functions that use callbacks to functions that return promises."
---

# A brief detour into asynchronous functions
The `Promise` object in Javascript is based on a concept in concurrent programming
proposed a long time ago (in the 1970's).

This concept sought to handle the situation where an operation during the execution
of a program was spun off into another thread or process, and the main thread was
allowed to keep on executing even though the __asynchronous__ operation hadn't
returned a value yet.

Consider the following:

```javascript
function somethingSync() {
  console.log('done executing somethingSync');
}

function somethingAsync() {
  setTimeout(() => {
    console.log('done executing somethingAsync');
  }, 1500);
}

let op1 = somethingSync();
console.log('After somethingSync')

console.log('');
console.log('------======------');
console.log('');

let op2 = somethingAsync();
console.log('After somethingAsync');
```

At first glance, one might expect that the `console.log` statements would appear
in the following order:

1. `done executing somethingSync`
1. `After somethingSync`
1. [wait 1.5 seconds]
1. `done executing somethingAsync`
1. `After somethingAsync`

Let's see what actually happens:

![Demonstration of sync vs. async function execution](https://i.imgur.com/hwRncky.gif)

As you can see, the __actual flow__ of the functions is:

1. `done executing somethingSync`
1. `After somethingSync`
1. `After somethingAsync`
1. [wait 1.5 seconds]
1. `done executing somethingAsync`

This is because Javascript's event loop allows the main execution of the program
to continue after registering an asynchronous function's callback in the
event queue.

Once the asynchronous function is registered, the remaining statements of the
program are allowed to execute.

# The inadvertent rise of callback hell
By the very definition of asynchronous code, we've no knowledge of _when_ it will
finish, just that it will be sometime between the present and the future.

Because of this, there is a notion in Javascript of "callback functions", or
functions that are passed in as parameters to asynchronously executing functions
that get called when the asynchronous function has completed.

The `setTimout` function is a great example of this: it accepts a callback as
its first parameter and then has that callback executed once the pre-determined
time has elapsed.

```javascript
setTimout(function myCallback() {
// function body
}, 2000);
```

---

A single level of asynchronous action may not seem incredibly difficult to handle.

If we had a function like the `somethingAsync` mentioned earlier, we could have
it receive a callback and invoke the callback once the asynchronous action completed.

```javascript
function async1(cb) {
  setTimeout(cb, 1500);
}

somethingAsync(() => {
  console.log('I\'m executing after async');
});
```

The real trouble comes from __several, consecutive asynchronous functions__ that each
depend on the one before it to have finished executing.

```javascript
function async1(cb) {
  console.log('async1 has completed')
  setTimeout(cb, 1500);
}

function async2(cb) {
  console.log('async2 has completed')
  setTimeout(cb, 2000);
}

function async3(cb) {
  console.log('async3 has completed!');
  setTimeout(cb, 2500);
}

async1(() => {
  async2(() => {
    async3(() => {
      console.log('Nested like crazy!');
    });
  });
});
```

In the above case we'd want the following to happen:

* Only execute the inner `console.log` when `async3` has completed
* Only execute `async3` when `async2` has completed
* Only execute `async2` when `async1` has completed

When we want several actions to happen sequentially because they depend on each
other we often run into this "callback hell" (also sometimes known as the "pyramid
of doom").

The problem usually lies in the difficulty of parsing each successive level of
the pyramid as well as the order in which everything happens.

# Promises: Make async code prettier
Promises are a different way to handle asynchronous code and provide
an alternative to the nested, callback hell that most Javascripters
are familiar with.

Conceptually, a Promise is very similar to those small, electronic
buzzers that restaurants like Outback Steakhouse or Shake Shack give
their customers to indicate when their table or order is ready.

![Shake Shack buzzer as an analogy for a Javascript Promise](https://i.imgur.com/UNOHKLl.jpg)

It takes some operation that requires an unknown amount of time (your
table freeing up) and wraps it in an notification system that alerts
you when it's time.

Similarly, libraries that are written using promises (many popular ones
are these days) allow you to use that interface to retrieve your values.

A Promise is said to _resolve_ when the asynchronous operation that
it is waiting on succeeds and returns a value. The __resolution of a promise__
can be likened to your Shake Shack buzzer going off, indicating your table's ready.

---

# Promises: Resolving and Rejecting
The best way to understand how promises work is to construct several
promise-returning functions of your own. Let's work through an example
right now.

How would we convert the functions we worked with earlier (the ones
that used setTimeout) to instead return a Promise?

```javascript
function myExecutor(resolve, reject) {
  setTimeout(() => {
    resolve('I\'m executing inside of somethingAsync');
  }, 1500)
}

function somethingAsync() {
  return new Promise(myExecutor);
}
```

There are several things going on here so let's break them down:

1. Every constructor for a Promise requires an __executor function__.
  * We've defined one here, called `myExecutor`
1. Every executor function must be defined with two parameters: `resolve`
and `reject`.
  * These two parameters represent the two routes the asynchronous
  function call can take (it can either succeed or fail).
1. Finally, the asynchronous call will happen in the body of the executor. Upon
success, `resolve` will be invoked with the value of interest.
  * In this case, the string "I'm executing inside of somethingAsync"

# Promises: Getting to your value with `then`
Now that we know what a Promise looks like from the inside, let's dig into how
they're used when we have a function that returns them.

---

Promises are something known as "then-able" objects, meaning they respond to a
method called `then`.

This `then` method accepts a function whose first argument represents the
resolution value of the promise when it was created.

Let's take another look at the function above, `somethingAsync` and see if we
can determine what our resolution value is:

```javascript
function myExecutor(resolve, reject) {
  setTimeout(() => {
    resolve('I\'m executing inside of somethingAsync');
  }, 1500)
}

function somethingAsync() {
  return new Promise(myExecutor);
}

let prm = somethingAsync();
prm.then(resValue => {
  console.log(resValue);
});
```

![Logging to output the resolution value of a promise](https://i.imgur.com/MC2JTCw.png)

As you can see above, the first argument to `resolve` was what ended up being
logged in the `then` function.

This goes a long way to flattening out the __callback hell__ that we were seeing
earlier with the nested `setTimeout` calls by providing a common, non-nested interface
to get at the function.

Finally, let's try refactoring our earlier example to use promises instead of
callbacks.

```javascript
function async1() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve('async1 has completed');
    }, 1500);
  });
}

function async2() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve('async2 has completed');
    }, 2000);
  });
}

function async3() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve('async3 has completed');
    }, 2500);
  });
}

async1().then(val => {
  console.log(val);
  return async2();
}).then(val => {
  console.log(val);
  return async3();
}).then(val => {
  console.log(val);
});
```

![Demonstration of the output of the Promises approach](https://i.imgur.com/TNA5sMy.gif)

---

Hopefully this article has been a gentle introduction in the minimum necessary
to start working with Javascript promises.

As always, I'd love to hear from you, the readers, on any questions you might
have with regards to either this topic or any other that you're interested in
reading about!
