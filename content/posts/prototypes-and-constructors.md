---
title: "Prototypes and the Constructor Function"
date: 2018-01-17
tags: ["javascript", "prototypes", "constructor"]
draft: false
meta_description: "In this post, we take a look at Javascript's constructor
function and its implications on the prototype object. We also examine how to add
methods to an object's prototype so children of that prototype can inherit them."
---

In a previous article, I wrote at length about [prototypes in Javascript](/posts/demystifying-prototypes). Today, I'm going to go in-depth into
Javascript's constructor function and explore the different implications that
it has on an object's prototype.

# The constructor
In a nutshell, a __constructor function__ is one that creates and returns an
object whose prototype is set to __the same object__ as the `prototype` attribute
of the constructor function.

I know this above sentence is long and confusing, so let's break it down into
concrete steps.

First let's take a look at __declaring the constructor__. Those of you familiar
with Object-Oriented Programming from other languages may liken this concept
to a class constructor or initializer:

```javascript
function Company() {
  // Constructor function body goes here
}

let comp = new Company();
```

Just a couple of things to note here right off the bat:

* Semantically, there's no difference between a constructor function and a regular
function. Functions can be executed in several ways, two of which are:
    * Prefixed by the `new` operator: `new Company();`
    * Invoked by name: `Company();`
* The capitalized name of the constructor function is NOT a requirement and is
simply a stylistic choice that the community generally agrees on to denote a
constructor versus a regular function.

# The Constructor's `prototype`

It's important to note that when a function is declared, it has a special `prototype`
attribute set on it that is linked to a prototype object.

Additionally, every time a constructor function is invoked with the `new` keyword,
it returns an object whose prototype is set to __the same prototype object__ that's
yielded by the function constructor's `prototype` attribute.

This was a common source of confusion for me, but I was finally able to sort it out
when I realized that `[constructor].prototype !== Object.getPrototypeOf([constructor])`

Let's see what this looks like when it's evaluated:

![Comparison of a Function's prototype attribute and a Object's prototype](https://i.imgur.com/bhxCi8P.png)

The actual prototype of the function itself is neither related to the `prototype`
attribute nor the prototype of objects returned by it. The naming is somewhat
unfortunate, however the distinction is important.

![Comparison of the constructor's prototype and the prototype attribute](https://i.imgur.com/UbOHLly.png)

Next, let's take a look at using a Constructor's `prototype` attribute to give
all of its children member methods.

# Declaring on and Inheriting from `[Constructor].prototype`
In this section, we're going to delve into the building blocks of
Object Oriented programming principles and how to use both the prototype object
as well as the constructor function to create what resembles a class in other
languages.

First, let's create a `Car` constructor and give it a `fuel` attribute:

```javascript
function Car() {
  this.fuel = 'Gasoline';
}
```

Notice, that we use the `this` keyword here. It allows us to declare a `fuel`
attribute on every object created with the constructor. Thus, every object
returned by `new Car()` will respond to a `car.fuel`.

Let's declare a `drive` function on the `prototype` attribute of `Car`:

```javascript
Car.prototype.drive = function() {
  console.log('Vroom vroom!');
}
```

What we're doing here is declaring a `drive` key in the `Car.prototype` object
and setting its value equal to a function that executes a `console.log` statement.

Let's take a look at what the effect is of declaring this function:

![Demonstration of declaring a function inside of [Constructor].prototype](https://i.imgur.com/cdJTFsc.png)

As you can see above, after adding the function to the prototype, it becomes
available as a member function of each object. This would be analogous to a
__public instance method__ in classical-inheritance based languages.

# `this` within the constructor and prototype functions

One last thing that I wanted to call attention to was the `this` object which
behaves as somewhat of a "state" object when referenced within the constructor
function and functions added to the `prototype` attribute.

Any changes made to the `this` object from within the scope of any one of the
above referenced functions will result in those changes being visible from
within the scope of any of the other functions.

For instance:

```javascript
function Car(fuel) {
  this.fuel = fuel;
}

Car.prototype.cleanEnergy = function() {
  if (this.fuel === 'Gasoline') {
    console.log('Down with fossil fuels!');
    return false;
  }
  this.epaApproval = true;
  return true;
}

Car.prototype.showThis = function() {
  console.log(this);
}
```

In the above example, we alter the constructor slightly to accept a `fuel`
argument that we then assign to `this.fuel`. We can now call the constructor
by entering `new Car('Gasoline');`.

Let's look at a working example:

![Showing the this object of a constructor function](https://i.imgur.com/csnfHCp.png)

---

The concept of inheritance is an important one in learning about object-oriented
design. However, be careful not to create inheritance chains that run too long
or are otherwise more complex than they have to be.

Simpler code, more often than not, pays dividends in the future.
