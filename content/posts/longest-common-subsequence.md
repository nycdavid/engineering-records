---
title: "Dynamic Programming: Longest Common Subsequence"
date: 2018-09-16
tags: ["algorithms", "dynamic programming", "golang", "CS8803", "longest common subsequence"]
draft: false
mathjax: true
meta_description: "We study how to create an efficient algorithm for solving
a cousin of the LIS problem: the longest common subsequence problem."
---

# The Problem
Imagine we had two different character strings:

```
A = ABAACDAB
B = ACAABCAB
```

The main goal of today's post will be to design an efficient algorithm by which we're
able to find the longest common subsequence between two strings.

As we are already aware of the definition of the longest subsequence, let's define the
longest __common__ subsequence:

> Assuming there are two strings `A` and `B`, the longest common subsequence between
  them is a subsequence in `A` that can also be found in `B`.

For example, from the above two strings, we can see that the longest common subsequence
is the subsequence `AAACAB`, with length 6.

# The Subproblem Definition
What would an initial pass at our subproblem definition look like?

$$
Def. (1) \\\\\\
L(i) = \text{length of the longest common subsequence from } a_1 \text{ to } a_i
$$

However, if something struck you as odd about this subproblem definition, you'd
be correct! 

Right off the bat, it seems strange that we are defining \\(L\\) in terms of a 
single variable, when we're concerning ourselves with two different lengths.

Let's try again, but this time with a multivariable definition that represents
the lengths of the different strings.

$$
Def. (2) \\\\\\
L(i, j) = \text{length of the longest common subsequence from } a_1 \text{ to } a_i \\\\\\
\text{ and } b_1 \text{ to } b_j
$$

Thanks to this now stronger subproblem definition, we're able to adjust the ending
characters independently between the two strings.

Let's try defining a recurrence relation with the aid of the above subproblem 
definition and see what we get:

$$
L(i, j) = 
\begin{cases}
1 + L(i-1, j-1) & \text{ if } a_i = b_j \\\\\\
\max{(L(i, j-1), L(i-1, y))} & \text{ otherwise.}
\end{cases}
$$

In the first case, which is the situation in which the ending characters of both
strings are the same, we know that we can simply add 1 to the solution of
the problem \\(L(x-1, y-1)\\). 

In the case below it, we're accounting for the scenario in which the ending 
characters are __not__ the same, in which case we start to see branching.

When the ending characters are not the same, we need to build in support for
comparing \\(a_i\\) to \\(b\_{i-1}\\) or \\(a\_{i-1}\\) to \\(b_i\\). 

Put simply, we want to be able to compare the strings while independently 
varying the ending characters a single character at a time. This allows us 
to fully utilize the leverage that introducing a 2nd dimension provides us.

# The Code
We'll again be implementing this algorithm in Go, and we should have all of the
pieces we need from the recurrence relation to infer the code:

{{<highlight go "linenos=true,hl_lines=15 19 21-23">}}
package main

import (
  "fmt"
)

func main() {
  A := []string{"A","B","A","A","C","D","A","B"}
  B := []string{"A","C","A","A","B","C","A","B"}
  sol := LCS(A, B)
  fmt.Println(sol)
}

func LCS(A, B []string) [][]int {
  T := make([][]int, len(A)+1)
  for idx, _ := range T {
    // this call to make automatically handles 
    // the setting of our base case
    T[idx] = make([]int, len(B)+1)
  }
  for i := 1; i <= len(A); i++ {
    for j := 1; j <= len(B); j++ {
      if A[i-1] == B[j-1] {
        T[i][j] = 1 + T[i-1][j-1]
      } else {
        T[i][j] = max(T[i-1][j], T[i][j-1])
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

There are some important points to single out here:

* When generating the solutions table, we generate __one more__ than the length of
  the string.
    * __Line 15__: Here we create an initial slice that represents the table,
      but we create `len(A)+1` of them, rather than simply enough elements to
      match the length of the string.
    * __Line 19__: We're iterating through each element of the table and creating a
      slice of `int` types, but again we allocate memory `len(B)+1` for each.
    * The reason we do this is because, although we have `len(A)` or `len(B)` elements,
      we also have to account for the base case, which are the cases in which an empty
      string is compared with the other.
* Our conditional in the `for` loops is __inclusive__ of the right-hand bound. 
    * __Line 21-22__: Rather than `i` going to `len(A)-1` & `len(B)-1` and terminating, 
      it runs once more. This is due to the +1 length that we discussed earlier.
* We search for the `i-1` or the `j-1` character of the string.
    * __Line 23__: We have to do this because the variables `i` and `j`, depending on
      where we are in the function, represent both the __position in the string__ and 
      the __position in the solutions table__.
