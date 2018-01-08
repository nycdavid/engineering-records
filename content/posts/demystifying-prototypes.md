---
title: "Demystifying Javascript prototypes"
date: 2018-01-08
tags: ["javascript", "prototypes"]
draft: false
meta_description: "In this post, we take a look at Javascript prototypes and what exactly they are, how to get to them and why they're important in the eventual discussion of Object-oriented design."
---

# Have you heard of prototypes?
Depending on where you are in your Javascript journey, you may already be aware
of the concept of prototypes, whether in passing or having already dove fully into
them in your work. You also may have heard that Javascript uses
__prototypal inheritance__.

This blog post will serve as a foundational primer to conceptually understand
what a Javascript prototype serves as and the different ways in which it
can be used.

# Sharing is caring
In most cases, a `prototype` can be thought of as an object that behaves like any
other object in that it can __hold functions and attributes as key-value pairs__.

Let's say we had had any ol' object that had some key-value pairs in it: some
attributes and some function declarations.

If we then created a second, empty object, we could set the prototype of that
second object equal to the first object and presto! We can now access the
attributes and invoke the functions on the second object as if they were
originally declared on it. In this way, prototyping allows the "sharing" of methods
between prototype and object.

This above paragraph may have been quite confusing so let's break it down in a
code example.

```javascript
let AmericanCitizen = {
  officialLanguage: 'English',
  president: 'Donald Trump',
  allegiance: 'To the flag of the United States of America',
  goVote: function() {
    console.log('I\'m Barack-ing the Vote!');
  }
}

let David = {}
```
In the above code snippt, the `AmericanCitizen` object isn't anything special.
It was declared as a simple object and given several string values and a function
value.

`David` is an empty object. It has no attributes and no functions. Thus, if I
tried things like `David.officialLanguage`, I would get a return value of
`undefined`:

![Trying to invoke methods on an object when it has no prototype link](https://i.imgur.com/iDWQ3eZ.png)

We can use the built-in `Object.setPrototypeOf()` method to change an objects
prototype. Let's use that to set the prototype of `David` to `AmericanCitizen`
and see what happens:

![After setting the prototype, demonstration of the methods newly available](https://i.imgur.com/Ev5QIc1.png)

Voilà! The `David` objects prototype is now set to `AmericanCitizen` and it can
now do everything that `AmericanCitizen` can do!

# They're links, not copies
It's also important to note this subtle distinction: setting the prototype
of an object is __creating a prototypal link__ from that object to the prototype
object. It does NOT copy the key-value pairs into a new object.

```javascript
let AmericanCitizen = {
  officialLanguage: 'English',
  president: 'Donald Trump',
  allegiance: 'To the flag of the United States of America',
  goVote: function() {
    console.log('I\'m Barack-ing the Vote!');
  }
}

let David = {};
Object.setPrototypeOf(David, AmericanCitizen);

Object.getPrototypeOf(David) === AmericanCitizen;
//=> true
```

It's also worth noting that because it's a link rather than a distinct copy, any
changes made to the prototype object __automatically propagate to its children__.

This allows for some nifty runtime modifications, like adding methods or changing
attributes, long after the code has been loaded. For example:

![Changing a prototype attribute during runtime](https://i.imgur.com/tyWFJ5q.png)

The automatic propagation may not be so impressive in the above example, but consider
the example where there were hundreds of objects that all had their prototype as
`AmericanCitizen`.

If prototypes were copies rather than links, someone would have to go and
manually change every objects prototype to reflect the new attribute!

# The Prototype Chain
For the sake of an example, let's say that the relationship between an object
and its prototype are akin to residents of countries, states and counties in the
United States.

![Inheritance chart for an AmericanCitizen](https://i.imgur.com/80a87ww.png)

As we can see above, an individual who lives in New York State, can not only
claim membership in the "New York Resident" set, but also in the "US Resident"
set. That is to say, a resident of New York is also a resident of the United
States.

Similarly, a resident of Queens County (a county within the Metro New York City
area), is also a resident of both New York State AND the US. These attributes
are reflected in the example below:

```javascript
const USResident = {
  usResident: true
};

const NYResident = {
  nyResident: true
};

const QueensCountyResident = {
  QueensResident: true
};
```

Although each entity has an attribute that accurately reflects its own set (i.e.
`NYResident` has an `nyResident` attribute that evaluates to true), how do we get
an object like `QueensCountyResident` to respond to `usCitizen`?

The answer is: __the prototypal chain__!

As mentioned earlier, prototypes are Javascripts main paradigm for allowing
inheritance between objects. We can use the prototypal chain to define what would
be known in classical inheritance-based languages as __subclasses__ and
__superclasses__.

What then, would our previous example look like in code? Naturally, it'd make the most sense to set
the prototype of `QueensCountyResident` to `NYResident`, and set the prototype
of `NYResident` to `USResident`:

```javascript
const USResident = {
  usResident: true
};

const NYResident = {
  nyResident: true
};

const QueensCountyResident = {
  QueensResident: true
};

Object.setPrototypeOf(NYResident, USResident);
Object.setPrototypeOf(QueensCountyResident, NYResident);
```

Now that the prototype chain has been properly set up, we can create objects that
have the attributes of their direct prototype, but also attributes of their
"prototypal ancestors"!

Javascript achieves this by examining the current object (the one the attribute
was invoked on), and looking for the attribute. If it doesn't find it there,
it looks at the objects prototype and so on, until it gets to the `Object`
prototype at the top of the chain. If not found here, it returns `undefined`.

![Code snippet demonstrating prototypal inheritance](https://i.imgur.com/ieq1jQh.png)

As you can see in the above code snippet, the `David` object has all attributes
of an `NYResident` and a `USResident` but NOT a `QueensCountyResident`. This is
because inheritance only works in one direction, thus, look-ups along the prototype
chain only move UP the chain.

---

Thanks for bearing with me through what ended up being a much longer post than I
planned! Hopefully this clears up a lot of mystery surrounding the Javascript
prototype object and how it can be used!

Look forward to seeing many more posts related to design patterns and the like.
Thanks for reading!
