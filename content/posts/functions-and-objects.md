---
title: "Javascript: Functions and Objects"
date: 2018-01-04
tags: ["javascript", "functions", "objects"]
draft: false
meta_description: "In this post, we learn about the interactions between Javascript functions and objects, including a brief look at the this keyword inside of an object function. We also touch briefly on the role of objects in Object-oriented design."
---

# Functions & Objects
In this post, we'll be exploring the relationship between __objects__ and
__functions__ in Javascript.

In its most basic sense, an Object in Javascript can be thought of as a set of
__key-value pairs__, where all the keys are unique. Analogous concepts in other
languages include a __hash in Ruby__ or a __map in Go__.

We'll be diving into the following:

* How to get and set properties on Objects
* How to declare functions in Objects
* How to use those functions to access an objects attributes

# Getting and setting properties on objects
First, let's start by declaring an empty object using the __object literal syntax__.

This is done most easily by:

```javascript
let person = {};
```

Now, there are a handful of ways that one may set properties on an object, but
we'll only cover the three most popular ways:

* ### Setting on initialization:
    Values in objects can be set along with the declaration in the object literal
    syntax by placing the key-value pairs between the curly braces:

    ```javascript
    let person = {
      name: 'David'
    };
    ```

* ### Using dot (.) notation:
    By taking the object and an attribute name, and separating them with a dot,
    we can set the attribute of an object much like someone would handle variable
    assignment:

    ```javascript
    let person = {};

    person.name = 'David';

    person.name;
    //=> 'David'
    ```
* ### Using square brackets:
    Similar to other languages, the name of an attribute can be enclosed with
    square brackets and placed adjacent to the object name in order to access
    the value at that position:

    ```javascript
    let person = {};

    person['name'] = 'David';

    person['name'];
    //=> 'David'

    // Ex. 2

    let attr = 'lastName';

    person[attr] = 'Ko';
    ```

    We can even set the attribute name in a variable to be used as the key in
    the square bracket notation, as seen in Ex. 2, which affords us a bit of
    dynamic expressiveness when writing our code.

# Deleting a property on an object
Say we didn't have a use for a property on an object any longer and we wanted to
get rid of it.

Javascript allows us several ways to get rid of an Object property:

* ### Set the value to null or an empty string:
    It may not be accurate to include this method in here, but it can certainly
    be done this way. We can simply set the value that the key points to to an
    empty string or null value.

    ```javascript
    let person = {
      name: 'David'
    };

    person.name = '';
    ```

* ### Use the `delete` operator:
    The `delete` operator will not only remove the value, but it will also remove
    the key, erasing any trace of the property from the object.

    ```javascript
      let person = {
        name: 'David'
      };

      delete person.name;
      person;
      //=> {}
    ```

# Declaring a function inside of an object
Now to the fun stuff! Strings and numbers aren't the only types of values that
can be set inside of an object. We could even __declare a function__ as a member
attribute of an object like so:

```javascript
let person_1 = {
  sayName: function(name) {
    console.log('My name is', name);
  }
}

let person_2 = {};
person_2.name = function(name) {
  console.log('My name is', name);
}
```

## Object functions and `this`
Something very special happens when we declare a function inside of an object:
we get access to a `this` variable that __refers to the object itself__.

In the previous example, we had the following code:

```javascript
let person_1 = {
  sayName: function(name) {
    console.log('My name is', name);
  }
}
```

As you can see here, we have to pass in a name parameter so there isn't much
significance in having this function reside inside of the `person_1` object. It
could be declared outside of the object and still perform the same operation.

What if we wanted to design the `person_1` entity to be self-contained? We would
like to have a function that, when invoked, can tell us its objects name without
any external intervention.

That's there the `this` object comes in handy!

Let's change the above example slightly:

```javascript
let person_1 = {
  name: 'David',
  sayName: () => {
    console.log('My name is', this.name)
  }
}
```

Now you can see that we've add a `name` attribute and changed the `sayName`
function to fetch `this.name` rather than accept a name as a parameter.

![nodejs REPL demo of javascript function in object using this](https://i.imgur.com/AIUBHUc.png)

---

The above concept of tying in all related attributes and functions and unifying
them in a single entity is a great introduction to a broad and useful topic:
object-oriented design.

Look forward to my next post on diving a bit more into Object-Oriented design
with Javascript! As always, please let me know what you thought of the post
in the comments below!
