---
title: "(DPV 6.1) Maximum Sum of a Contiguous Subsequence"
date: 2018-09-05
tags: ["algorithms", "dynamic programming", "subsequence", "golang", "CS8803", "DPV"]
draft: false
mathjax: true
meta_description: "A look at problem 6.1 from the Algorithms textbook by DPV where
we are tasked with creating an algorithm that finds the contiguous subsequence that
yields the highest sum of all subsequences."
---

# The Problem
Imagine we have some sequence `A = [5, 15, -30, 10, -5, 40, 10]`. 

The question that we're asking is: 

> How do we define an algorithm that traverses the sequence and determines a 
  contiguous subsequence that, when summed, yields the highest value?

Let's be sure to mention the definition of a __contiguous__ subsequence here,
which is a subsequence of the sequence whose values are consecutive. 

For example, the subsequence `B = [5, 15]` *would* be contiguous, whereas, 
`C = [5, -30]` would *not* be contiguous.


# The Subproblem Definition (attempt #1)
Let's try defining our subproblem as:

$$
S(i) = \text{the maximum sum yielded by a contiguous subsequence from } a_1 
\text{ to } a\_i
$$

# The Recurrence Relation (attempt #1)
Basing our relation off of the above subproblem definition, we may be tempted
to draft something like this:

$$
S(i) = a\_{i - 1} +
\begin{cases}\\
0 & \text{ if } a_i < 0 \\\\\\
a_i & \text{ otherwise}
\end{cases}\\
$$

However, the above simply takes a previous solution and adds \\(a_i\\) to it
if the value is positive. There's nothing built in to account for wanting
to start a new subsequence for an iteration, if that's deemed advantageous.

This would be the case if, for example, the current \\(a_i\\) is simply
greater in value than adding it to a previous solution.

This recurrence, although close, does not quite fit our needs. Thus, we must
strengthen the subproblem.

# The Subproblem Defintion (attempt #2)
Because we want to account for the situation in which isolating an element
by itself is more advantageous than adding it to a subsequence, let's change
our subproblem to be:

$$
S(i) = \text{the maximum sum yielded by a contiguous subsequence from } \\\\\\
a_1 \text{ to } a_i \text{ that includes } a_i
$$

This now allows us to *start a new* subsequence if the current \\(a_i\\) value
is greater than the value of adding it to the previous subsequence.

# The Recurrence Relation (attempt #2)
Now, given our new subproblem definition, we can define the recurrence as:

$$
S(i) = \max(a_i, a_i + S(i - 1))
$$

What we're doing here is we're calculating \\(S(i)\\) by calculating two values:

* \\(a_i + S(i - 1)\\)
* \\(a_i\\)

and then taking the greater of the two values to get \\(S(i)\\). 

# The code
Let's try to model this recurrence in code and see if our algorithm actually works:

{{<highlight go "linenos=true">}}
package main

import (
  "fmt"
  "sort"
)

type SortableTable []int

func (n SortableTable) Less(i, j int) bool {
  return i < j
}

func (n SortableTable) Swap(i, j int) {
  n[i], n[j] = n[j], n[i]
}

func (n SortableTable) Len() int {
  return len(n)
}

func main() {
  nums := []int{5, 15, -30, 10, -5, 40, 10}
  fmt.Println(contig(nums))
}

func contig(nums []int) int {
  T := make([]int, len(nums))
  T[0] = 0

  for i := 1; i < len(nums); i++ {
    if nums[i] > nums[i] + T[i-1] {
      T[i] = nums[i]
    } else {
      T[i] = nums[i] + T[i-1]
    }
  }
  sort.Sort(SortableTable(T))
  return T[len(nums)-1]
}
{{</highlight>}}

And as we can see [this Go code](https://play.golang.org/p/ZFLWbxuzzso) does, 
in fact, yield `55`, which is the solution for this set of numbers.
