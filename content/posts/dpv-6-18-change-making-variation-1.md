---
title: "(DPV 6.18) Making Change (Variant 1)"
date: 2018-10-18
tags: ["algorithms", "dynamic programming", "golang", "CS8803", "DPV"]
draft: false
mathjax: true
meta_description: "Problem 6.18 from the Algorithms textbook by DPV where we write an
algorithm that determines whether or not we can make change for a certain value given
a set of coin denominations, but use of each coin is limited to one time."
---

# The Problem

> Given coins of denominations \\(x_1, x_2, \ldots, x_n\\) and the restriction of
  __only using each coin, at most, once__ we wish to make change for a value \\(v;\\) 
  that is, we wish to find a set of coins whose total value is \\(v\\). 

> Give an \\(O(nv)\\) dynamic programming algorithm for this problem.

Note that in certain scenarios, making change may not be possible, like when 
\\(v = 12\\) but all we have are coins of denomination 5 and 10.

In short:

* __Input__: \\(x_1, \ldots, x_n; v\\)
* __Question__: Is it possible to make change for \\(v\\) using coins of denomination
  \\(x_1, \ldots, x_n\\)?

On to the subproblem definition!

# The Subproblem Definition
$$
D(v, i) = \text{change can be made for value $v$ using coins $x_1, \ldots, x_i$}
$$

As we can see, this is going to be a two dimensional table with \\(v\\) along the 
vertical axis and \\(i\\) along the horizontal.

Let's see if we can determine what the base cases are:

* \\(D(0, i)\\): this is the case where the value is zero. Of course we'll be able
  to make change for this value and so we would place `true` all along the vertical
  axis where \\(v = 0\\)
* \\(D(v, 0)\\): in this case, we'd have no coins available to use, thereby unable
  to make change. This would input `false` all along the horizontal axis where 
  \\(i = 0\\).

# The Recurrence Relation
Let's think through the different cases for the above problem to design a recurrence
relation:

* __The coin \\(x_i\\) is GREATER than \\(v\\)__
  * We cannot take the coin and must use the solution \\(D(v, i-1)\\)
* __The coin \\(x_i\\) is LESS than or EQUAL \\(v\\)__
  * __If we decide to take the coin__:
      * then the subsequent value that we must fulfill becomes \\(v-x_i\\)
        * we can attempt to find the solution to this subproblem by looking for 
          \\(D(v-x_i, i-1)\\)
        * Notice that we use \\(i-1\\) because now that we've used coin \\(x_i\\), we no
          longer have it available to us.
        * The solution to \\(D(v, i)\\) takes on whatever value \\(D(v-x_i, i-1)\\) ends up
          being.
  * __If we decide NOT to take the coin__:
      * We must use the solution \\(D(v, i-1)\\)

In the case where \\(x_i \leq v\\), we will make the decision on whether or not to take
the coin by choosing the one that's `true`.

With all of the branches laid out above, we can now formalize the recurrence relation:

$$
D(v, i) =
\begin{cases}
  D(v, i-1), & \text{if } x_i > v \\\\\\
  D(v-x_i, i-1) \lor  D(v, i-1), & \text{if } x_i \leq v
\end{cases}
$$

# The Code
{{<highlight go "linenos=true">}}
package main

import (
  "fmt"
)

func main() {
  coins := []int{2, 4, 6, 8}
  V := 10
  makeChange(V, coins)
}

func makeChange(V int, coins []int) {
  T := make([][]bool, V+1)
  for idx, _ := range T {
    T[idx] = make([]bool, len(coins)+1)
  }
  for idx, _ := range T[0] {
    T[0][idx] = true
  }
  for v := 1; v <= V; v++ {
    for i := 1; i <= len(coins); i++ {
      xi := coins[i-1]
      if xi > v {
        T[v][i] = T[v][i-1]
      } else {
        T[v][i] = T[v-xi][i-1] || T[v][i-1]
      }
    }
  }
  fmt.Println(T)
}
{{</highlight>}}
