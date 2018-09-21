---
title: "The Knapsack Problem: Variant 1"
date: 2018-09-21
tags: ["algorithms", "dynamic programming", "golang", "CS8803", "knapsack", "optimization"]
draft: false
mathjax: true
meta_description: "We study how to create an efficient algorithm for solving
the knapsack optimization problem."
---

# The Problem
In today's problem we're going to take a look at the knapsack problem, in which 
you're given a an imaginary knapsack (bag) that can hold up to a specific amount
of weight.

You're then given several items of various weights and values and the task of
determining which of these items you'd want to place in your bag to maximize
value while subject to the constraint of an upper limit on weight.

Let's set up a sample example and define its components:

* We have a bag that can hold a max weight of \\(B\\)
* We have a set of objects \\(O = (o_1,...,o_n)\\) that have values 
  \\(v_1,...,v_n\\) and weigh \\(w_1,...,w_n\\)

The problem we have to optimize is defined mathematically as:

$$
\max_{v} \sum\_{i=1}^{n} v_i \\\\\\
\textrm{s.t.} \sum\_{i=1}^{n} w_i \leq B \\\\\\
$$

The above constrained optimization problem attempts to get the greatest possible
value whilst still adhering to the constraint that the bag we have can only
hold at or below a specific weight \\(B\\).

The dynamic programming algorithm we have to design must be able to traverse
through each item in \\(O\\) and select a subset of the items properly such that
they conform to the above restriction.

## The Items
Let's say that we have items according to the following table:

Object # | Value | Weight
---------|-------|-------
1        | 15    | 15
2        | 10    | 12
3        | 8     | 10
4        | 1     | 5

Additionally, let's say that we have a bag that can hold a max weight of 
\\(B = 22\\).

How would we solve this problem of item selection? There are two methods that
we'll examine, one of which will not be correct for this type of problem.
We'll take a look at that first.

### The Greedy Algorithm
We can describe the greedy approach to optimization as:

> making the locally optimal choice at each stage with the intent of finding
  a global optimum

In this particular scenario, a greedy approach could be that we figure out
what the __unit value__ \\(U\\) of each item is and base our selections
on that.

Let's add a column to our table with the calculated \\(U\\):

Object # | Value | Weight | \\(U\\)
---------|-------|--------|--------
1        | 15    | 15     | 1
2        | 10    | 12     | 0.83
3        | 8     | 10     | 0.8
4        | 1     | 5      | 0.2

The greatest unit-value object is of course object 1, so we can select that.
However, because of the weight constraint of our bag, we're unable to select
any item aside from the last one, object 4, which we do.

Now we're left with a bag containing items 1 and 4, with values totaling 16.

But if we look closer we can see that this solution is indeed suboptimal. If
we had selected item 2 as our first (suboptimal) choice and then item 3, we'd 
get a higher value (18), while still adhering to our weight restriction.

It's evident that the greedy approach won't work for our situation.

### Dynamic Programming approach

Let's start by defining our subproblem definition:

$$
L(i) = \text{the optimal selection of items within } a_1 \text{ to } a_i
$$

Before we leave it at that, let's try to detect any __traps__ before we fall 
into them.

Given the above subproblem definition, what would happen when applying it
to an itemspace at the edge? 

Let's say we only had an itemspace of length 1 (a single item to choose from). 
Obviously, in this case, we'd select that item to put into our bag. 

However, let's say that we then increase the itemspace to 2. Our recurrence 
relation will have to derive a solution to \\(L(i)\\) by looking at 
\\(L(i-1)\\) which, by virtue of our subproblem definition, selects item 1.

The rigidity of our subproblem definition prohibits us from backtracking our
decision to \\(L(i-1)\\), which may very well be necessary.

Let's redefine our subproblem definition:

$$
L(i, b) = \text{max possible value using a subset of objects } a_1 \text{ to } a_i \\\\\\
\text{ and where total weight is } \leq b
$$

Breaking down the above, we can see the following points:

* We're now accepting two different arguments \\(i\\) and \\(b\\), which represent
  parameters for the subproblem:
    * \\(i\\) represents the \\(ith\\) item, where \\(0 \leq i \leq n\\)
    * \\(b\\) represents the max capacity for the bag and varies between 
      \\(0 \leq b \leq B\\)
      

# The Recurrence Relation
Before diving into the recurrence relation, let's conceptualize the different
scenarios that are possible:

* Item \\(a_i\\) fits in our backpack (\\(w_i \leq b\\))
    * In this case, if we decide to include \\(a_i\\), we can add \\(v_i\\). We'd also 
      have to pass \\(b - w_i\\) as parameter \\(b\\) into our recurrence relation to
      account for the space now taken up by \\(a_i\\)
    * If we decide __not__ to include \\(a_i\\) then we can simply fetch
      the solution for the previous subproblem for the given weight \\(b\\)
    * Of these two cases, we'll take whichever the \\(\max\\) is.
* Item \\(a_i\\) does __not__ fit in our backpack (\\(w_i > b\\))
    * Nothing we can do here, so we execute the same scenario as in the
      exclusion case from above

From the above bullet points, we can derive the following recurrence relation:

$$
L(i, b) = 
\begin{cases}
\max(v_i + L(i-1, b-w_i), L(i-1, b)) & \text{if } w_i \leq b \\\\\\
L(i-1, b) & \text{if } w_i > b
\end{cases}
$$

Let's also determine our base cases:

* \\(L(0, b)\\): in this scenario, we have no items to choose from, thus every 
  entry would be 0
* \\(L(i, 0)\\): here, our bag cannot hold any weight, thus every entry would
  again be 0.


Now that our recurrence relationship and base cases have been determined, we 
should have everything we need to model it.

# The Code

{{<highlight go "linenos=true">}}
package main

import (
  "fmt"
)

func main() {
  items := []map[string]int{
    {"item": 1, "value": 15, "weight": 15},
    {"item": 2, "value": 10, "weight": 12},
    {"item": 3, "value": 8, "weight": 10},
    {"item": 4, "value": 1, "weight": 5},
  }
  
  fmt.Println(knapsack(items, 22))
}

func knapsack(items []map[string]int, weight int) [][]int {
  T := make([][]int, len(items)+1)
  for i, _ := range T {
    T[i] = make([]int, weight+1)
  }

  for i := 1; i <= len(items); i++ {
    for j := 1; j <= weight; j++ {
      wi := items[i-1]["weight"]
      vi := items[i-1]["value"]
      if wi <= j {
        T[i][j] = max(vi+T[i-1][j-wi], T[i-1][j])
      } else {
        T[i][j] = T[i-1][j]
      }
    }
  }
  return T
}

func max(i, j int) int {
  if i > j {
    return i
  }
  return j
}
{{</highlight>}}

Caveats to mention here:

* Remember to allocate an additional slot for the base case in the table, if
  the language you're using allows memory management.
* Ensure that we don't conflate which rows pertain to \\(i\\) in the table, 
  and which rows pertain to \\(j\\).
* Remember that we have to index the `items` slice with `i-1`, because we're
  including the right bound in our loop.
