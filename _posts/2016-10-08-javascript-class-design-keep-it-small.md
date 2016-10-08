---
layout:     post
published: true
title:      "JavaScript Class Design: Keep it small"
subtitle:   "Make your public API with as few seams as possible."
date:       2016-10-08 12:00:00
author:     "David Ko"
header-img: "img/post-bg-01.jpg"
---

If you've been involved with OO programming for some amount of time you've undoubtedly written countless classes and methods. What is a class exactly, though? The analogy that I like to use (both when explaining and designing) is that a class is an outline of *what an object can do*. The name of the class is obviously taken from the real-life concept that you're trying to model and it's methods are an outline of the various abilities it has. For instance:

```javascript
  class PizzaCreator {
    pipingHotPizza() {
      // code related to producing a pizza
    }
  }
```

In the above case, a pizza creator is able to product a piping hot pizza, thus the `PizzaCreator` class has the method `pipingHotPizza()`. However, when designing, I like to take it one step further and introduce the ideas of a distinct *public* and *private* API. That is, I separate the methods of a class into public methods that can be invoked from the outside and private methods that can only be invoked internally. An example:

```javascript
  function gatherIngredients() {
    // buying tomato sauce...
  }

  class PizzaCreator {
    pipingHotPizza() {
      const pizza = gatherIngredients().flattenDough().placeInOven();
      return pizza;
    }
  }
```

Presumably, any entity that creates `PizzaCreator` objects has a need for the value that is returned by the `pipingHotPizza()` method (in this case, the object `pizza`). Furthermore, I would even go so far as to say that the existence of the *intermediate steps* involved when invoking `pipingHotPizza` (`gatherIngredients(), flattenDough()`, etc.) need not be known outside of the class itself, because of the following reasons:
* The number of steps involved in `pipingHotPizza()` is irrelevant to the functioning of it. The responsibility of `pipingHotPizza()` is to execute the steps (however many they may be) and then return the object so it can be used elsewhere.
* Over time, it's possible for the functioning of `pipingHotPizza()` to change. Maybe delivering pizza no longer needs to involve `gatheringIngredients()` anymore. It's natural for apps to evolve over the course of their life and so this scenario is quite possible. However, if the interface of the `PizzaCreator` class stays the same, and it still has the same old `pipingHotPizza()` method, regardless of how the method functions internally, it's still delivering (no pun intended) value to the system in which it's used.

---

# Why does it matter whether or not a method is public or private?
## #1 More public methods === more unit tests
This distinction is important because the list of public methods that a Class has is it's contract with the other objects that it plays with. If I'm a developer that walks into a project and sees that the `PizzaCreator` class has a `pipingHotPizza()` method, I'm going to expect that every single object of class `PizzaCreator` CAN and WILL respond to `pipingHotPizza()`. The explicit agreement there is "*Yes. You're free to write more code that depends on `pipingHotPizza()`. It's free game.*" Because of this agreement, we as good developers, must test our code and ensure that behaves the way that we (and others) expect it to under a multitude of different circumstances.

However, the private methods that make up `pipingHotPizza()`? There's no need to even know they exist, unless they're being invoked externally. And when are they invoked externally? When knowledge of whatever operation they're executing provides some value to an outside party.

Let's assume our customer is a poor, college student who's ravenous after a night of drinking. As long as `pipingHotPizza()` returns a `pizza` object, does it matter if it was crafted with the finest ingredients or picked up in the frozen food aisle for $5? 3rd parties that use the `pipingHotPizza()` method need it to return a `pizza` and that's what it does. If it ever stops doing that (due to accidental refactoring's, bungled rebases, etc.), a properly written unit test will fail. Thus, we only write tests for `pipingHotPizza()` because the pizza it returns is the only thing that is important to the hungry customer that invoked it.

Suppose our customer, later on, develops a much more discerning taste and requires every `PizzaCreator` that they interact with to present them with a guarantee that states that they always use organic ingredients. That's perfectly fine. It represents the evolving needs of our customers and, by default, our system. This would signal a need that outside entities now require another window from which to peer inside of and interact with the operations of `PizzaCreator`.

```javascript
  class PizzaCreator {
    reassureCustomer() {
    }

    pipingHotPizza() {
    }
  }
```

Remember though, that we are responding to a NEED for another opening in the public API. Every method, although providing value to our customers, still represents another pathway by which outside influence can maliciously undermine the operations of our class. This is simply the cost of doing business here. Opening the door to your home allows good friends to enter, but it allows burglars in as well. Without security, this open door will, without reservation, allow everyone (friend or foe) to come in. Implementing security? More overhead and more code (Think guard clauses, if/else statements, type checking, etc.). The cognitive load doesn't end there. This added opening and the security to lock down that opening requires more tests too. What happens when a User sends in `null`? An integer when the method expects a string? These all translate to test-cases that have to be covered now that the method can be called from wherever.

Thus we should increase the number of public methods cautiously and only with good reason. If our customer doesn't care that their pizza is made of organic ingredients, why create a method that provides that exact information just for it to be used internally and nowhere else?

## #2 Making all methods public allows invocation at ANY time.
Imagine our class had two methods that were designed to be called one after the other:

```javascript
  class PizzaCreator {
    constructor() {
      this.ingredients = [];
      this.gatherIngredients();
      this.bake();
    }

    gatherIngredients() {
      this.ingredients = // add cheese, pepperoni, etc. to the array
      return this;
    }

    bake() {
      this.pizza = // act on our collection of ingredients and return a pizza
    }

    pipingHotPizza() {
      return this.pizza;
    }
  }
```

What would be the general way in which we would use this class if all we wanted was a pizza? We'd probably instantiate it and then check on it sometime after instantiation to get the finished pizza. But the user of the class (the Customer) also has access to the `gatherIngredients()` and `bake()` methods, two things they didn't really ask for nor really need. What would happen if the user just repeatedly called `gatherIngredients()` on an instance of `PizzaOrder`? All of the intermediate steps have already been called in the constructor and the finished pizza is ready to be picked up, but because `gatherIngredients()` is on the public API it's open to being called any number of times, at any time and by whom or whatever. If the method is linked to some inventory system that automates the ordering of ingredients when they're low on stock, we're immediately open to huge inefficiencies and difficult to trace bugs and side effects.

## #3 Multiple unrelated public methods imply that a class has multiple unrelated responsibilities.

My last point has to do with a class's list of methods and what it implies about the responsibilities it has. Let's continue with our `PizzaOrder` class:

```javascript
  class PizzaOrder {
    constructor() {
      this.ingredients = [];
      this.gatherIngredients();
      this.bake();
    }

    slicePizza(pizza) {
      pizza.slice();
    }

    gatherIngredients() {
      this.ingredients = // add cheese, pepperoni, etc. to the array
      return this;
    }

    bake() {
      this.ingredients.forEach(ingredient => {
        // mix the ingredients and throw in the oven
      }.bind(this));
      return this;
    }

    finishedPizza() {
      this.slicePizza(this.pizza);
      return this;
    }
  }
```

Now we can see that our class's methods are getting a bit out of hand. `slicePizza()` isn't even acting on `this` when it operates, as it receives a `pizza` argument and does what it has to do to *that* object, meaning other Users could use that method to slice other pizza objects completely unrelated to the functioning of this specific instance. The addition of this method to public interface implies to those that use it that this class is responsible for slicing pizza *in addition* to making the pizza. One way you could think about it is that, it's effectively similar to saying, "I'm going to use the PizzaOrder to cut the pizza into slices." Of course this wouldn't make any sense, whatsoever.

A more sensible refactoring might look like this instead:

```javascript
  class PizzaTool {
    static slice(pizza) {
      // code related to slicing up a pizza
    }
  }

  class PizzaCreator {
    constructor() {
      this.pizza = new Pizza();
    }

    pipingHotPizza() {
      const slicedPizza = PizzaTool.slice(this.pizza);
      return slicedPizza;
    }
  }
```

Here we use ES6's `static` keyword to indicate that we'd like to call the method directly on the `PizzaTool` class, similar to how you'd define a Ruby class method on `self`. It separates out the slicing of a pizza into a different module and keeps the roles and responsibilities of `PizzaCreator` as small as needed.

---

Hopefully this has convinced you that it's best to only expand on a class's public API when absolutely necessary. Any other behavior that doesn't need to be observed is best left hidden from the outside, as it simply interferes with not only a developer understanding how to use the class, but can cause unintended side effects in the system in which it operates.

I hope to write much more on this topic in the months to come, and I'll look forward to hearing everyone's comments then as well!
