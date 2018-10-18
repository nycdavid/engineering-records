---
title: "(DPV 6.17) Making Change"
date: 2018-10-15
tags: ["algorithms", "dynamic programming", "golang", "CS8803", "DPV"]
draft: false
mathjax: true
meta_description: "Problem 6.17 from the Algorithms textbook by DPV where we write an
algorithm that determines whether or not we can make change for a certain value given
a set of coin denominations."
---

# The Problem

> Given an unlimited supply of coins of denomination \\(x_1, x_2, \ldots, x_n\\),
  we wish to make change for a value \\(v\\); that is, we wish to find a set of coins
  whose total value is \\(v\\). Given an \\(O(nv)\\) dynamic programming algorithm
  for the following problem.

Note that in certain scenarios, making change may not be possible, like when 
\\(v = 12\\) but all we have are coins of denomination 5 and 10.

In short:

* __Input__: \\(x_1, \ldots, x_n; v\\)
* __Question__: Is it possible to make change for \\(v\\) using coins of denomination
  \\(x_1, \ldots, x_n\\)?

Let's take a stab at the subproblem definition.

# The Subproblem Definition

$$
C(v) = \text{proposition that change can be made for $v$ with the} \\\\\\
\text{multi-set $\\{x_1,\ldots,x_n\\}$}
$$

A mis-step that I made the first time around was assuming that there would be more than
one parameter to the function \\(C\\) because of the multi-set. 

If we can get away with simpler parameters for the subproblem and recurrence, we
should seek to do that.

# The Recurrence Relation

$$
C(v) = \underset{1 \leq i \leq n}{x_i}
\begin{cases}
  C(v-x_i) & \text{if $x_i \leq v$} \\\\\\
  false & \text{otherwise}
\end{cases}
$$

Breaking down this recurrence:

* We vary \\(x_i\\) between 1 and \\(n\\).
* If \\(x_i > v\\), we return \\(false\\).
* If \\(x_i \leq v\\) then we return the value of \\(C(v-x_i)\\)
  * This is the important bit. What we're doing is calculating and storing solutions
  to \\(C(v)\\) where the \\(v\\) is exactly equal to \\(v-x_i\\).
  * We do this because we know that if \\(C(v)\\) is possible with coins 
  \\(x_1,\ldots, x_i\\) then \\(C(v-x_i)\\) is also possible using the same
  denominations and choosing \\(x_i\\) as one of the coins.

What is our base case? When \\(v=0\\), the value would be __true__, because we
can always make change for nothing.

# Code
{{<highlight go "linenos=true">}}
package main

import (
  "fmt"
)

func main() {
  makeChange(10, []int{1, 2, 4, 5, 6, 7})
}

func makeChange(V int, coins []int) {
  T := make([]bool, V+1)
  T[0] = true
  for v := 1; v <= V; v++ {
    for _, x_i := range coins {
      if x_i > v {
        break
      }
      T[v] = T[v-x_i]
    }
  }
  fmt.Println(T)
}
{{</highlight>}}

# Takeaways
* Try to keep the parameters as few as possible. Don't assume right away that 
  there will be more than one.
* How can we use former values to deduce current values? 
    * We used the fact that if change can be made for \\(v\\) with coins 
      \\(x_1,\ldots,x_i\\) then it's safe to say that change can be made for \\(v-x_i\\) 
      with \\(x_i\\) and \\(x_1,\ldots,x\_{i-1}\\).
