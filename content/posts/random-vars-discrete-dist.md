---
title: "Probability in Javascript: Random Variables & Distributions"
date: 2018-02-06
tags: ["probability", "statistics", "random variables", "distributions"]
draft: false
meta_description: "In this post, we're going to be "
---

# The Sample Space
In this post, we're going to get introduced to a probability modeling concept
called a __random variable__.

From the _excellent_ textbook __Probability and Statistics__ by Morris H.
Degroot & Mark J. Schervish:

> A random variable is a real-valued function defined on a sample space.

Before we dig into what that actually means, let's first visualize the idea of
probability with a real-world example: the roll of a 6-sided die. More specifically,
the sequence of __5 rolls of a 6-sided die__.

As most of you may know, a conventional 6-sided die will have each of the numbers
1-6 notated on each face of the die.

Now, let's pretend that our task is to map out __all of the possible outcomes__
of our 5 throw experiment and write them each down on a scrap of paper like
`5-4-1-1-6`, where that means:

* The 1st throw was a 5
* The 2nd throw was a 4
* The 3rd & 4th throws were 1's
* And the last throw was a 6

We conduct the above experiment enough times where we get __every possible
5-part outcome__. That is to say: \\((1,1,1,1,1)\\), \\((1,1,1,1,2\\)),
\\((1,1,1,1,3)\\), etc. We put every scrap of paper we have into a big box which we
call __the sample space__.

This sample space (the box) will have \\(6^5 = 7,776\\) scraps of paper in it.

# Random Variable
When declaring a __random variable__, the purpose is to ask a question that can
be answered using our __sample space__ or information derived from it. An example
using our sample space from above would be:

* How many 4's show up in a single, given 5-roll experiment?

Expressed mathematically, let's say \\(S\\) represents the entire sample space
of possible 5-roll experiments. Thus, we would say:

$$
X(s\_n) = x \\\ x \in \mathbb{N} \\\ s\_n \in S
$$

Let's pause a second and work through this mathematical notation, piece-by-piece:

* \\(X(s\_n)\\): \\(X\\) is a function that receives, as a parameter/input, \\(s\_n\\)
    * Remember that the random variable \\(X\\) is the number of 4's thrown in any
    given experiment.
    * \\(s\_n\\) represents any one 5-throw experiment in the sample space of
    all possible 5-throw experiments \\(S\\), so \\(s\_1\\) would be experiment 1,
    etc.
* \\( = x \\): \\(x\\) will be the number of times that 4 shows up in the 5 rolls
of experiment \\(s\_n\\)
* \\(x \in \mathbb{N}\\): This is stating that \\(x\\) _is a member_ (\\(\in\\))
of set \\(\mathbb{N}\\), which are the __natural numbers__. The natural numbers set
in mathematics includes __all positive integers__ including 0.
    * In a nutshell, this is saying that the number of 4's in any \\(s\_n\\) will
    always be a positive integer or zero. And this makes perfect sense: we wouldn't
    be able to say "there were negative two 4's in this experiment".
* \\(s\_n \in S\\): This means that the input, \\(s\_n\\), will always be a member
of the sample space \\(S\\)

---

Let's say our first 3 experiments were the following:

$$
s\_1 = (3,5,1,3,4) \\\ s\_2 = (1,4,3,4,6) \\\ s\_3 = (3,6,6,2,1)
$$

Thus, we'd have the following calculations using our random variable \\(X\\):

$$
X(s\_1) = 1 \\\ X(s\_2) = 2 \\\ X(s\_3) = 0
$$

Let's take a brief detour to model the concepts of:

* Experiments
* The Random Variable

as Javascript code.

```javascript
// the random variable: number of 4's in a given experiment
const RandomVarX = {
  calculate: experiment => {
    let foursArr = experiment.results.filter(num => num === 4);
    return foursArr.length
  }
}

function Experiment() {
  this.results = [];

  for (var i = 0; i < 5; i++) {
    let num = randomIntBetween(1, 6);
    this.results.push(num);
  }
}

function randomIntBetween(min, max) {
  let randomFactor = Math.random(); // value between 0 and 1
  let range = max - min + 1;
  return Math.floor(randomFactor * range) + min;
}
```

![Demonstration of calculation code](https://i.imgur.com/QH6ikq5.png)

# Random Variable Distributions

The next topic that I wanted to touch on was the __distribution of a random
variable__.

Although the formal definition of a random variable distribution can be a bit
abstract and complex, effectively, what a random variable distribution amounts to
is: an __outline of all possible values__ of a random variable and their
respective __probabilities of occurring__.

There are different types of distributions but the one we'll start with is the
__discrete distribution__, so named because the random variable in question
__can only take discrete values__.

A good example of a discrete distribution would be our die throwing example from
above with the random variable \\(X\\) being the number of 4's appearing in the
experiment.

For any given experiment, the value of \\(X\\) can only be a finite integer value
between 0 and 5.

There are also specific probabilities associated with each value of \\(X\\) like:

* Probability of rolling no 4's in the experiment
* Probability of rolling one 4 in the experiment,
* etc.

This could be mathematically expressed as:

$$
f(x) =
\begin{cases}\\
Pr(X = 0), & \text{if \\(x\\) = 0}\\\\\
Pr(X = 1), & \text{if \\(x\\) = 1}\\\\\
Pr(X = 2), & \text{if \\(x\\) = 2}\\\\\
Pr(X = 3), & \text{if \\(x\\) = 3}\\\\\
Pr(X = 4), & \text{if \\(x\\) = 4}\\\\\
Pr(X = 5), & \text{if \\(x\\) = 5}\\\\\
\end{cases}\\
$$

where \\(Pr(X = 0)\\) is read as "the probability of the random variable \\(X\\)
taking on the value 0".

---

What a distribution seeks to provide for us is a way to answer the question of
"what is the probability of rolling three 4's?" and more generally: "what is
the probability that a random variable \\(X\\) takes on a specific value from a
set of all possible values?"

Thank you all for reading! My plan is dig more into Probability and modeling
probability in code, so expect more of these for as long as there is interest!

As always, let me know what you thought!
