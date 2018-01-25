---
title: "Promise-based code and Async/Await"
date: 2018-01-25
tags: ["javascript", "async", "await", "promises"]
draft: false
meta_description: In this article we learn about declaring async functions and waiting for promises to resolve via async/await. We'll go into converting previous async examples from the promise.then pattern to the async/await pattern.
---

# Enhancing Promise-based async Javascript
In a previous article, we examined asynchronous code and the difficulties of using
callbacks to handle such code. As a way to circumvent callbacks, we also took a
[closer look at using promises](/posts/understanding-promises/).

In today's article, we'll be looking at an enhancement to working with Promise-based
async code: the `async`/`await` keywords.

# We're still using callbacks

The whole purpose of the `async`/`await` construct is for programmers to be able
to write their asynchronous Javascript __in a synchronous way__.

Consider the following example:

```javascript
function asyncEcho(text) {
  return new Promise(resolve => {
    setTimeout(() => {
      return resolve(text);
    }, 1500);
  });
}

asyncEcho('1st async').then(val => {
  console.log(val);
  return asyncEcho('2nd async');
}).then(val => {
  console.log(val);
  return asyncEcho('3rd async');
}).then(val => {
  console.log(val);
});
```

Although this code is still much better than the usual callback hell, we __are
still__ passing callbacks into each `then`. Additionally, assigning the result
of the `asyncEcho` function would __store the promise__ rather than the value of
interest.

Taking all of these into account, it'd be fair to say that working with async code,
although made infinitely better by using promises, can __still be improved__.

# Assignment of a promise function

The `await` keyword allows us to write asynchronous code __as if it were asynchronous__. But to really understand the implications of this, examine the following code:

```javascript
function asyncEcho(text) {
  return new Promise(resolve => {
    setTimeout(() => {
      return resolve(text);
    }, 1500);
  });
}

(function() {
  let aE = asyncEcho('foobar');
  console.log('Value of aE:', aE);
})();
```

![Trying to run async promise in sync](https://i.imgur.com/Fugw3gT.png)

As you can see above, attempting to evaluate the asynchronous, promise-based
code in sync, results in the return value of `asyncEcho` being a promise, rather
than the resolution value. It also makes no guarantees of when (before or after
the promise resolves) the variable will be evaluated.

Certainly, we'd love to use this style of syntax where we don't have to pass in
a callback to a `then` invocation in order to get at the resolution value. This
is exactly what `async`/`await` allows us to do!

# `await` waits for your code

In order to successfully use `async`/`await`, our code must satisfy two conditions:

* Any function returning a promise may be prefixed by `await` to "halt execution"
when coming across the Promise.
* Any function declaration containing `await` directives must be prefixed with `async`.

Let's try re-writing the above code using `async`/`await` and see what we get when
we evaluate it:

```javascript
function asyncEcho(text) {
  return new Promise(resolve => {
    setTimeout(() => {
      return resolve(text);
    }, 1500);
  });
}

(async function() { // add async here
  let aE = await asyncEcho('foobar'); // add await here
  console.log('Value of aE:', aE);
})();
```

![Promise-based code using async/await](https://i.imgur.com/J0oKWF7.gif)

As you can see, the code above appears to execute in a nice, synchronous way
preventing the need for callbacks to retrieve future-resolving values.

Another nice addition is the fact that assigning the result of the `await` line
allows us to directly evaluate the variable and get the value of interest that
we expect.

# Is it blocking?
The main question that some may be asking is this: if the code is executing
synchronously, then __is the code blocking__?

The answer to this question is: __kind of__.

To really see what's going on under the hood, we have to know __when functions
are being invoked__ and __when promises are resolved__. The best way to tell
is to insert `console.log` statements strategically into the code and view
the execution.

```javascript
function asyncEcho(text) {
  console.log('asyncEcho invoked');
  return new Promise(resolve => {
    setTimeout(() => {
      console.log('asyncEcho resolved');
      return resolve(text);
    }, 3000);
  });
}

function asyncEchoRedux(text) {
  console.log('asyncEchoRedux invoked');
  return new Promise(resolve => {
    setTimeout(() => {
      console.log('asyncEchoRedux resolved');
      return resolve(text);
    }, 3000);
  });
}

(async function() {
  let aE = await asyncEcho('foobar');
  let aER = await asyncEchoRedux('barbaz');
  console.log('Value of aE:', aE);
  console.log('Value of aER:', aER);
})();
```

![console.logs within async/await functions](https://i.imgur.com/CwUJ4BD.gif)

As demonstrated above, the sequence of events are the following:

1. `asyncEcho` is immediately invoked, creating a Promise and starting the `setTimeout`.
1. [__3 seconds pass__]: the Promise inside of `asyncEcho` resolves, and `asyncEchoRedux`
is immediately invoked, starting a `setTimeout`.
1. [__3 seconds pass__]: the Promise inside of `asyncEchoRedux` resolves and the values
  of both `aE` and `aER` are logged to the console.

So, it could be said that the inside of a function declared to be `async` is blocking
, depending on the placement of the `await` keywords.

However, if an asynchronous call were placed outside of the `async` function, the
execution of this function would adhere to the original conventions that we're used
to regarding concurrency in Javascript.

Let's take a look at an example of that:

```javascript
function asyncEcho(text) {
  console.log('asyncEcho invoked');
  return new Promise(resolve => {
    setTimeout(() => {
      console.log('asyncEcho resolved');
      return resolve(text);
    }, 3000);
  });
}

(() => {
  (async function() {
    let aE = await asyncEcho('foobar');
    console.log('Value of aE:', aE);
  })();

  console.log('Does it get to me?');
})();
```

![console.log executing nearly immediately after async function](https://i.imgur.com/fwBEFJ6.gif)

The `console.log` statement executes nearly immediately, even though it comes
_after_ the `async` function declaration.

Thus, we can say that, although, the lines in an `async`-declared function _can_
execute synchronously, lines outside of the declaration generally do not.

# Exercises
Try these programming problems out on your own and leave a comment with your findings!

1. Convert the following callback-based code to the `async`/`await` pattern:

```javascript
setTimeout(() => {
  console.log('Stage 1');
  setTimeout(() => {
    console.log('Stage 2');
    setTimeout(() => {
      console.log('Stage 3');
    }, 1000);
  }, 1000);
}, 1000);
```
