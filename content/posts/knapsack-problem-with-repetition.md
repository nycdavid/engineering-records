---
title: "The Knapsack Problem: Variant 2 (with Repetition)"
date: 2018-09-29
tags: ["algorithms", "dynamic programming", "golang", "CS8803", "knapsack", "optimization"]
draft: false
mathjax: true
meta_description: "A very similar problem to the original knapsack problem expect
now we allow for repeated use of elements."
---

# The Problem
We're going to take another look at the knapsack problem, but now, rather than
only allowing a single copy of each element, we now have the option to use
multiple copies of each, if deemed optimal.

# The Subproblem Definition
The subproblem definition will be very similar to the earlier variant of knapsack
except that the set of items will now be a __multiset__, which is defined as:

> ...a modification of the concept of a set that, unlike a set, allows for multiple 
  instances for each of its elements.

Let's redefine our subproblem as follows:

$$
K(i, b) = 
\begin{aligned}
& \text{max value attainable from a multiset of objects } \\{1,...,i\\} \text{ with } \\\\\\ 
& \text{weight }\leq b
\end{aligned}
$$

# The Recurrence Relation
As always, let's define our base cases to the problem, although at this point,
I'm sure it's pretty obvious what they'll be:

* \\(K(0, b) = 0\\)
* \\(K(i, 0) = 0\\)

Before we try to make sense of the recurrence, let's first build out a solutions
table so that we can intuit the correct choices. We'll borrow our constraints from
the previous knapsack post:

\\(B = 22\\)

Object # | Value | Weight
---------|-------|-------
1        | 15    | 15
2        | 10    | 12
3        | 8     | 10
4        | 1     | 5

Let's try drawing out the solutions table:

\\(i \downarrow b \rightarrow \\) 

   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22
---|---|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|----|----|----|----
 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0  | 0 
 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0  | 0  | 0  | 0  | 0  | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15
 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0  | 0  | 10 | 10 | 10 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15
 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 8  | 8  | 10 | 10 | 10 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 18
 4 | 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1 | 1 | 1 | 8  | 8  | 10 | 10 | 10 | 15 | 15 | 15 | 15 | 15 | 16 | 16 | 18

Now, let's get to the meat of the recurrence:

$$
\begin{align}
X(i, b) &= K(i-1, b) \\\\\\
Y(i, b) &= v_i + K(i, b-w_i) \\\\\\
K(i, b) &= \max{(X(i, b), Y(i, b))}
\end{align}
$$

* \\((1)\\) details the situation where we have \\(b\\) weight available to us
  and decide __not__ to take item \\(a_i\\).
    * In this situation, we simply calculate \\(K\\) for \\(i-1\\) and the unchanged
      weight \\(b\\).
* \\((2)\\) details the situation where, again, \\(b\\) is available but now we
  decide to take item \\(a_i\\).
    * Here we add the value \\(v_i\\) of \\(a_i\\), but notice that we __again__ 
      pass in \\(i\\) as the parameter rather than \\(i-1\\).
    * This clues us in to the fact that we're able to select an unlimited quantity
      of any item, if that maximizes our value.
* Finally, \\((3)\\) has us calculate both and take the \\(\max\\) value.

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
  
  fmt.Println(knapsackWithRep(items, 22))
}

func knapsackWithRep(items []map[string]int, b int) [][]int {
  T := make([][]int, len(items)+1)
  for idx, _ := range T {
    T[idx] = make([]int, b+1)
  }

  for i := 1; i <= len(items); i++ {
    for j := 1; j <= b; j++ {
      thisItem := items[i-1]
      if thisItem["weight"] <= j {
        X := T[i-1][j]
        Y := thisItem["value"] + T[i][j-thisItem["weight"]]
        T[i][j] = max(X, Y)
      } else {
        T[i][j] = T[i-1][j]
      }
    }
  }
  return T
}

func max(a, b int) int {
  if a > b {
    return a
  }
  return b
}
{{</highlight>}}
