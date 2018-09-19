---
title: "Discrete Distributions & Probability Functions"
date: 2018-02-12
tags: ["probability", "statistics", "probability functions", "distributions"]
draft: false
mathjax: true
meta_description: "In this post, we're going to be taking a closer look at
discrete random variables, as well as what their distributions look like. We'll
also be defining a probability function for these discrete distributions."
share_img: "https://i.imgur.com/qU9otdF.png"
---

# Probability between zero and one
In a previous post, I went into the basics of
[random variables and distributions](/posts/random-vars-discrete-dist/) and
touched on the possible values of an expression such as \\(Pr(X = 1)\\).

Assuming that the __random variable__ \\(X\\) is the side that comes face up
after a fair, six-sided die is tossed once, the question of \\(Pr(X = 1)\\)
becomes:

> What is the probability that the faceup side is the side with one dot?

The answer to this, of course, would be \\(\frac{1}{6}\\) because, if each side
of the die is equally likely to be the faceup side on any given throw, the side
with a single dot is one of six sides, hence \\(\frac{1}{6}\\).

Furthermore, the we can see that if we add up all of the probabilities of each
side being the face up side we get:

$$
\begin{align}
Pr(X = 1) + Pr(X = 2) + Pr(X = 3) +
\\\ Pr(X = 4) + Pr(X = 5) + Pr(X = 6) &=
\\\ &= \frac{1}{6} + \frac{1}{6} + \frac{1}{6} + \frac{1}{6} + \frac{1}{6} + \frac{1}{6}
\\\ &= 1
\end{align}
$$

The sum of the probabilities of the possible values of a random variable will
__always__ equal 1, and this is proven to be true because each value of the
random variable has some __likelihood of occurring__ expressed as a __percentage,
fraction or decimal__. And because, together, they represent the entire probability
space.

This can be expressed mathematically as:

$$
\text{Let \\(f(x\_n) = Pr(X = n)\\)}
\\\ \sum_{n=1}^{6} f(x\_n) = 1
$$

Let's break down the above mathematical notation:

* First, we declare the function \\(f(x\_n)\\) to equal \\(Pr(X = n)\\)
  * What that means is that: \\(f(x\_1)\\) is function notation for \\(Pr(X = 1)\\)
* Next, we declare sigma (\\(\sum\\)) notation, which is a __summation__.
  * The __lower bound__ (the \\(n = 1\\) in \\(\sum_{n=1}^{6}\\)) is the value
  that we __start with__.
  * The __upper bound__ (the \\(6\\) in \\(\sum_{n=1}^6\\)) is the value that we
  __end with__.

Also note the following ways in which we can express the summation:

$$
\begin{align}
  \tag{1} \sum_{n=1}^6 f(x\_n)
  \\\ \tag{2} f(x\_1) + f(x\_2) + f(x\_3) + f(x\_4) + f(x\_5) + f(x\_6)
  \\\ \tag{3} Pr(X = 1) + Pr(X = 2) + Pr(X = 3) + Pr(X = 4) + Pr(X = 5) + Pr(X = 6)
\end{align}
$$

Expressions \\((1)\\), \\((2)\\) and \\((3)\\) are all equivalent and are simply
ways of showing the summation of a sequence.

Furthermore, because the sum of these probabilities represents the sum of the
probability of the entire sample space, we can see that the expression
\\(\sum_{n=1}^{6} f(x\_n) = 1\\) is true.

# Discrete Distributions
A __discrete distribution__ is a distribution of a random variable where the
random variable can only take on a __fixed number of values__.

This means that there is a __finite set__ of values that are possible for the
random variable being examined in an experiment.

For instance, let's say that our random variable \\(X\\) is the same one from
above: the side that shows on any given toss of a fair die? In each experiment,
only one value be face up at a time. Additionally, the random variable
can only take on __six possible values__: the numbers 1-6.

Thus, it is said that \\(X\\) has a __discrete distribution__.

# Probability (Mass) Function

Now that we:

* Know all of the possible values of \\(X\\)
* Know all of their respective probabilities of occurring.

we can now define a __probability function__ for \\(X\\).

A __probability function__ is one where we provide an input value for \\(x\\)
and we get the probability of that value occurring as an output. You may also
hear it referred to as a __probability mass function__ or \\(\text{p.m.f}\\) in
the case of discrete distributions.

Let's draw up a probability function as a piecewise function for our random
variable \\(X\\):

$$
f(x) =
\begin{cases}\\
Pr(X = 1) = \frac{1}{6} & \text{if \\(x\\) = 1},\\\\\
Pr(X = 2) = \frac{1}{6} & \text{if \\(x\\) = 2},\\\\\
Pr(X = 3) = \frac{1}{6} & \text{if \\(x\\) = 3},\\\\\
Pr(X = 4) = \frac{1}{6} & \text{if \\(x\\) = 4},\\\\\
Pr(X = 5) = \frac{1}{6} & \text{if \\(x\\) = 5},\\\\\
Pr(X = 6) = \frac{1}{6} & \text{if \\(x\\) = 6},\\\\\
0 & \text{otherwise}
\end{cases}\\
$$

Notice that in the very last case of our piecewise function, we put that the
probability is \\(0 \text{ otherwise}\\). This is to acknowledge the fact that
no other \\(x\\) input has the possibility of occurring aside from the ones
that we've outlined in our cases.

This makes sense because no other value aside from the numbers 1-6 are possible
when rolling a six-sided die. Thus, the probability of rolling an 8, for instance,
would be assigned 0, if that value were to be given to our \\(\text{p.f.}\\)
as an input.

---

Discrete distributions and their probability (mass) functions are important because
of the information they provide about the probability of an event given some value
of a random variable. Always remember the distinction that if a random variable
can only take on a set number of values, it has a discrete distribution!
