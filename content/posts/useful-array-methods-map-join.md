---
title: "Useful Methods Series: Array.map & Array.join"
date: 2018-01-11
tags: ["javascript", "arrays"]
draft: false
meta_description: "In this post, we'll examine one of my favorite methods on Array.prototype: Array.map and Array.join. We'll also examine some of their real-world applications and how you can get started using them today."
---

# Arrays: The programmer's workhorse.
Even if you're just starting out in programming, chances are it won't take very
long for you to come across an array. Whether you're working through some
example online or playing with a result received from a 3rd party library, __arrays
are everywhere__!

And for good reason! They're one of the most useful data structures in all of
programming because they represent one of the most useful real-world objects:
a plain ol' box.

I can only go so far with my two hands, right? If I'm going shopping, the
maximum items that I can __safely__ grab are limited by my physicality. But if
I have a cart, basket or box, what I can get on that trip changes.

Similarly, __arrays afford us a place to store items__ and come back to them at a
later time. But _just_ storing them becomes boring after awhile. I mean, we want
to __do something__ with them! That's why we've stored them in the first place.

Today, I'll be analyzing two different methods that can be called on arrays that
I've found very useful and some examples that I've come across in my career thus
far. Let's dive in!

---

# How to: `Array.prototype.map`
The best way to describe using `map` on an array would be: if you want to take array A
and __transform it into a different array__ B, use `map`.

> Use `map` when you need to transform one array into another one.

Let's take a look at the semantics of using map:

```javascript
// 1.
const fruits = ['apples', 'oranges', 'pears'];

// 2.
function mapper(element, idx, array) {
  // element: either 'apples', 'oranges', 'pears', depending on which iteration
  // idx: either 0, 1 or 2, depending on which iteration
  // array: ['apples', 'oranges', 'pears']


  return 'Eat ' + element;
}

// 3.
let health = fruits.map(mapper);
```

Before we take a look at what the code returns, there are a few important points
in the above code snippet that we should discuss:

As you can see in the method signature of the `mapper` function, it receives
3 arguments:

* `element`: an array element
* `idx`: the index of the element in the array
* `array`: the entire array itself

When invoking `map` on an array, the callback function that's provided (the `mapper`
function in our case) is invoked __once per element__. Each time the function
is executed, its arguments change according to which element the "map cycle" is on.

Take a look at the image below to get an idea of this:

![Code example demonstrating each iteration when calling map on an array](https://i.imgur.com/qinOAsd.png)

As you can see above, the function is executed 3 times as soon as `fruits.map(mapper)`
is called (once for each array item) and is __passed the next array item and index
on each turn__.

---
## Always return something
Aside from the above contrived example, you'll hardly ever find yourself writing
a mapper function that does not return anything.

> ALWAYS return something from your mapper function.

The return statement in a mapper function will determine what the elements of the
new array are. Usually, they end up being a derivative of the items of the original
array but they don't always have to be.

Here are a few examples of different mapper functions

```javascript
const fruits = ['apples', 'oranges', 'pears'];

function eatMapper(element, idx, array) {
  return ['Eat', element].join(' ');
}

function booleanMapper(element, idx, array) {
  if (element === 'apples') { // ALWAYS use triple equals
    return true;
  } else {
    return false;
  }  
}

function nothingMapper(element, idx, array) {
}

fruits.map(eatMapper);
fruits.map(booleanMapper);
fruits.map(nothingMapper);
```

And what does this look like when evaluated?

![Demonstrations of the above examples of Array.map](https://i.imgur.com/FBjBPcD.png)

Each new array is an array based on the elements in the input array (except
for the last one). We're given quite a bit of latitude as to what can go on in
the mapper function so I encourage everyone to experiment with it and see how
creative you can get.

__Just don't write any code that someone is going to have headache maintaining__.

Also, note that the elements in the array become `undefined` because that's the
default return value for a function when one is not specified.

__Always__ return a value from your mapper.

---

# How to: `Array.prototype.join`
The `join` method is much more straightforward than the `map` method and simply
involves taking the elements of an array and __joining them into a string__.

```javascript
const broken_sentence = ['They', 'say', 'seltzer', 'has', 'no', 'calories'];
```

If we now call `join` on this array, we will get a concatenated string created
from the elements of the array:

![Demo of using Array.join with no arguments](https://i.imgur.com/Njllfkp.png)

Notice that, in the above example, we haven't provided `join` with any arguments
and that the return string became a __comma-separated value__ string.

That's because the argument provided to `join` becomes the _separator_ to be placed
in between the elements in the final string. Omitting it makes the default separator
a comma (,).

Let's take a look at a few more examples where we change the separator to
different values:

```javascript
const broken_sentence = ['They', 'say', 'seltzer', 'has', 'no', 'calories'];

broken_sentence.join('');
broken_sentence.join('-');
broken_sentence.join(' + ');
broken_sentence.join(' ');
```

![Return values when using Array.join with different separator values](https://i.imgur.com/AZkVbBO.png)

---

# Combining `map` and `join` to create an HTML string
Let's now combine these two methods to do something that you could very well be
asked to do on the job: __creating an HTML string from an array__.

Suppose we had an array of meats (I __love__ BBQ) that we wanted to change into
an unordered-list in HTML:

```javascript
const favoriteMeats = ['Pork Belly', 'Chicken Drumstick', 'Rib Eye', 'Flank Steak'];
```

What we need to do with this array is produce a single HTML string that:

* Opens a `<ul>` tag
* Encloses each item with `<li>{meat goes here}</li>`

Luckily, with `map` and `join` now at our disposal, this is actually quite
straightforward:

```javascript
const favoriteMeats = ['Pork Belly', 'Chicken Drumstick', 'Rib Eye', 'Flank Steak'];

let listItems = favoriteMeats.map(function(meat) {
  return ['<li>', meat, '</li>'].join('');
});

listItems = listItems.join('');

const html = ['<ul>', listItems, '</ul>'].join('');
```

There are several things happening here, so let me break them down:

* In the mapper function, we're enclosing the `meat` within `<li></li>` tags to
produce an array of meat list-item tags.
* We are joining the `listItems` array into a string and __re-assigning__ the value
so that we're working with strings only.
* Finally, we enclose the string of HTML tags within an opening and closing `<ul></ul>`,
again using `join`, to complete our HTML snippet.

Here's an example of the executed code:

![Demonstration of creating an HTML string with Array.map and Array.join](https://i.imgur.com/iOhuhnJ.png)

---

`map` and `join` are some of the most practical methods in `Array.prototype`
because of their many uses.

Hopefully reading this post has expanded what you thought was possible with
these methods and will encourage you to get even more creative in your code.

If you liked this article and want to see more in-depth topics on Javascript and
Go, subscribe below!
