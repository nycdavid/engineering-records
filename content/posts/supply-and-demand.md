---
title: "Applications of Javascript: Supply and Demand"
date: 2018-02-01
tags: ["javascript", "applications", "microeconomics", "supply and demand"]
draft: false
meta_description: "In this post, we'll take a look at the economic forces of supply
and demand and see how we can model these concepts using Javascript."
---

Supply and demand are the most fundamental of economic concepts that seek to
answer the following questions:

* What price are consumers __willing to pay__ for an item vs. at what price are
producers/manufacturers __willing to supply__ that item?
* What is the __demand schedule__ (the quantity of an item consumers are willing to
buy at different prices)?
* What is the __supply schedule__ (the quantity of an item manufacturers are
willing to produce at different prices)?
* Where is the __equilibrium__? Meaning, at what price does the quantity that
producers supply match the quantity that consumers demand?

In this post, we'll seek to explain and answer the above questions using examples
and also learn how to model these concepts using __object-oriented Javascript__.

# A fake market
Before we proceed, we must name and explain a few players in the market that we're
describing as well as an example product that there's a market for and that we
can apply these models against.

Let's say our market is for __ball point pens__.

The __consumers in the market__ are buyers of ballpoint pens, like students,
business professionals, etc. The __producers in the market__ are manufacturers
of ballpoint pens, like Uniball or BIC.

The Javascript class definitions are trivial at this point because we do not yet
have any knowledge of the different agents in our model. However, for the sake
of completeness, let's define functions like the one below:

```javascript
function Consumer() {
  this.pensDemanded = 0;
}

function Producer() {
  this.pensSupplied = 0;
}
```

Let's see what the Demand curve looks like for consumers in this ballpoint pen
market.

# Demand Curve
Below is an example of a possible demand for ballpoints pens in our fake market:

![Ballpoint pen demand curve](https://i.imgur.com/R0PqQ7q.png)

There are several things here to note:

* The x-axis is __Quantity__, while the Y-axis is __Price__.
* The demand curve is __downward sloping__.

Intuitively, a downward sloping demand curve makes sense: if we were to trace
along the demand curve, we'd see that __as price decreases, consumers would want
to buy more__. This is similar thinking to when your favorite snack goes on sale,
you might purchase more to take advantage of the discount.

As we can see above, the average consumer of ballpoint pens will be willing to
purchase:

* __5 pens__ when the price is __$10.00__, but
* __10 pens__ when the price is __$5.00__

Let's briefly recall the formula determining the equation of a line and its slope:

$$
y - y\_1 = m(x - x\_1)
$$
$$
m = \frac{y\_2 - y\_1}{x\_2 - x\_1}
$$

Substituting our points into the equation, we get the following slope:

$$
m = \frac{10 - 5}{5 - 10}\\\ m = \frac{5}{-5} \\\ m = -1
$$

Now we can substitute our calculated slope into the formula for a line and get
the line equation:

$$
y - 10 = -1(x - 5)\\\ y - 10 = -x + 5\\\ y = -x + 15
$$

We can now add this function to [the prototype](/posts/prototypes-and-constructors)
of the `Consumer`, and it can be used to provide us with the number of pens
demanded for any given price:

```javascript
Consumer.prototype.quantityDemanded = price => {
  return -(price) + 15;
}

let david = new Consumer();
let quantityDemanded = david.quantityDemanded(5);
console.log(quantityDemanded);

//=> 10
```

As it happens, the quantity demanded by a consumer given a price is calculated by
taking a given price, negating it and adding 15.

# Supply Curve
Let's now take a look at a manufacturers supply curve:

![Depiction of a manufacturers supply curve](https://i.imgur.com/zqNYzD1.png)

The curve itself lives on the same graph as the Consumer demand curve, so quantity
and price are on the same axes, but the main difference is the fact that the
__supply curve is upward sloping__.

Again, let's intuit this: as we move along the supply curve, a manufacturer is
willing to supply more as market prices for its product increase, because it
stands to make __more money__ by doing so.

What we can tell from the graph above is that a manufacturer would be willing to
supply:

* __5 pens__ when the price is __$5.00__
* __10 pens__ when the price is __$10.00__

Calculating the slope and line equation using the formulae above, we get:

$$
m = \frac{y\_2 - y\_1}{x\_2 - x\_1} \\\ m = \frac{10 - 5}{10 - 5} \\\ m = 1
$$

---

$$
y - y\_1 = 1(x - x\_1) \\\ y - 5 = 1(x - 5) \\\ y - 5 = x - 5 \\\ y = x
$$

Thus, the manufacturer's supply decision __tracks the price__. Adding this to the
prototype of `Producer`, we get:

```javascript
Producer.prototype.quantitySupplied = price => {
  return price;
}
```

# Market Clearing Equilibrium
The last thing that we'll talk about is the economic idea of __equilibrium__.

Equilibrium is the __price at which the quantity supplied is equal to the quantity
demanded__. That means that there is neither an excess nor a shortage on the part
of the suppliers and that every consumer who wants to purchase a product (at
their price) is able to do so.

![Depiction of market clearing equilibrium](https://i.imgur.com/p9RjCTW.png)

Looking at the above graph where we depict a __market clearing equilbrium__, we
see that the price at which a __consumer's demand__ matches a __producer's supply__
is $7.50 per pen with 7.5 pens in the market.

Thus, there is neither an excess nor a shortage. However, let's take a look at
if the market price for pen's was set at \\(p\_0\\):

* Consumers would demand (because of the higher price) a relatively lower quantity,
\\(q\_0\\).
* Suppliers, however, would be willing to supply (again, because of the higher
price) a relatively higher quantity \\(q\_1\\).

And so we'd have suppliers wanting to profit off of the higher price and bringing
more pens to market, but consumers wanting to purchase less because of the
higher price. This would be an __excess__ and would prevent a market clearing
equilibrium.

---

To determine what this market clearing equilibrium price would be, we can equate
the supply and demand functions to each other and solve for their \\(x\\)
and \\(y\\) values:

$$
y = x \\\ y = -x + 15
$$

---

$$
x = -x + 15 \\\ 2x = 15 \\\ x = \frac{15}{2} \\\ x = 7.5
$$

---

$$
y = -x + 15 \\\ y = -(7.5) + 15 \\\ y = 7.5
$$

Equilibrium quantity supplied and quantity demanded end up being \\(7.5\\).

Thanks for reading, everyone! Hopefully this at-a-glance look at the supply and
demand curve in microeconomics has been an interesting and worthwhile read.
Economic theory was and continues to be a pet interest of mine so expect more
of these kinds of posts in the future!

Don't forget to subscribe!
