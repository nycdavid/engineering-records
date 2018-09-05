---
title: "Dynamic Programming: Longest Increasing Subsequence"
date: 2018-08-30
tags: ["algorithms", "dynamic programming", "golang", "CS8803"]
draft: false
mathjax: true
meta_description: "We take a look at creating an efficient algorithm for solving
the longest increasing subsequence problem."
---

# The Problem
Imagine we had an array of numbers: `[0, 6, 3, 4, 5, 7, 8, 9, 11]`

How would we find the length of the longest increasing subsequence 
of this array?

# Terminology
Let's first make some clarifications with regards to the terminology:

* __Subsequence__: a subset of a set of elements where each successive 
  element occurs later in the original sequence than the element before it.
    * Imagine we had a set:
        $$
          A = \(a_1, a_2, a_3, a_4, a_5\)
        $$
        A __subsequence__ of this set would be:
        $$
          B = \(a_1, a_3)
        $$
        but NOT:
        $$
          C = \(a_5, a_2\)
        $$
        Notice that in \\(B\\) we have the 1st element and *then* the 3rd element, 
        whereas, in \\(C\\), the 5th element if followed by the 2nd element, which
        disqualifies this set from being a __subsequence__ of \\(A\\)
* __Increasing__: a subsequence is increasing if each successive element has a value
  greater than the element before it.
    * Imagine the same set from before:
        $$
          A = \(a_1, a_2, a_3, a_4, a_5\)
        $$
        A subsequence, \\(B\\), of \\(A\\) would be __increasing__ if:
        $$
          B = \(a_1, a_3, a_5\) \land a_1 < a_3 < a_5
        $$
* __Longest__: There can be several increasing subsequences within a set. In this
  problem we want to find the longest.

# (Weak) Subproblem Definition
Let's define our subproblem as the following:

$$
K(i) = \text{the length of the longest increasing subsequence from } 
a_1 \text{ to } a_i
$$

Defining our subproblem in this way will allow us to build up our solutions
table from \\(0\\) (the base case) all the way to \\(i\\) (the solution that
we're seeking).

# The Recurrence Relation
Stating the recurrence simply requires that we define \\(K(i)\\) in terms of
\\(K(1)\\) to \\(K(i-1)\\)

If we can depend on \\(K(i-1)\\) to always provide us with the length of
the longest increasing subsequence from \\(a_i\\) to \\(a\_{i-1}\\), then
we need only concern ourselves with how the \\(ith\\) character will
affect our subsequence.

The above statement leads us to create a recurrence relation like the following:

$$
K(i) = K(i-1) +
\begin{cases}
0 & a_i \leq a\_{i-1}\\\\\\
1 & a_i > a\_{i-1}
\end{cases}
$$

Just to get an idea of what this table might look like, let's sketch out
a table containing the first few solutions:

$$
A = (0, 6, 3, 4, 5, 7, 8, 9, 11)
$$

 \\(i\\) | Subsequence     | \\(K(i)\\)
---------|-----------------|-----------
 0       |\\(\varnothing\\)| 0
 1       |\\((0)\\)        | 1
 2       |\\((0, 6)\\)     | 2
 3       |\\((0, 6)\\)     | 2
 4       |\\((0, 6)\\)     | 2
 5       |\\((0, 6)\\)     | 2
 6       |\\((0, 6)\\)     | 2

Notice that when \\(i = 3\\) our longest increasing subsequence stays \\((0, 6)\\)
and \\(K(i) = 2\\). Because \\(3 \ngtr 5\\), we cannot append \\(3\\) to the
current subsequence \\((0, 5)\\) 

However, there's a problem here! Notice that when \\(i = 6\\), we actually have a
better solution to \\(K(6)\\) than the subsequence \\((0, 6)\\).

If we simply look at the subsequence \\((3, 4, 5)\\) (the 3rd, 4th and 5th elements
of \\(A\\)), we get a longer increasing subsequence than \\((0, 6)\\).

The fact that the we were unable to detect this in our iterations indicates
a __weakness__ in our __subproblem definition__. In order to create a dynamic
programming algorithm that's correct, we must strengthen it. 

# (Strong) Subproblem Definition
Because we know that there can be more than one increasing subsequence of 
any given length, the optimal solution would be one that not only is the longest
but has the __smallest ending character__.

The way we can ensure that this happens is to change the subproblem definition
to the following:

$$
K(i) = \text{the length of the longest increasing subsequence between } a_1
\text{ to } a_i
\\\ \text{ that includes } a_i
$$ 

This definition requires us to include the current character as a requirement
within the subsequence.

Doing this ensures that we only generate subsequences that have an ending
character low enough to accommodate appending the current character.

$$
A = (0, 6, 3, 4, 5, 7, 8, 9, 11)
$$

 \\(i\\) | Subsequence      | \\(K(i)\\)
---------|------------------|-----------
 0       |\\(\varnothing\\) | 0
 1       |\\((0)\\)         | 1
 2       |\\((0, 6)\\)      | 2
 3       |\\((3)\\)         | 1
 4       |\\((3, 4)\\)      | 2
 5       |\\((3, 4, 5)\\)   | 3
 6       |\\((3, 4, 5, 7)\\)| 4

As we can see from the above, the subsequence changes quite a bit from 
when we had our original subproblem definition. 

# New Recurrence Relation
We can define a new recurrence as follows:

$$
L(i) = 1 + \max\_{\substack{1 \leq j \leq i \\\ a_j < a_i}} L(j)
$$

Deciphering the above notation, we can make the following statements:

* We're adding \\(1\\) in the beginning. Because we stipulated in the
  subproblem definition that we are including \\(a_i\\), we already
  know that, at a minimum, we'll have a subsequence length \\(l \geq 1\\).
* We're searching for all potential solutions to \\(L(j)\\) whereby:
    * \\(j\\) is varied between \\([1, i]\\)
    * \\(a_j < a_i\\) 
* Then, we pare down that solutions list to get the largest length.

# The code
Finally, let's write out code that models that recurrence relation above.

{{<highlight go "linenos=true,hl_lines=11 14-19">}}
package main

func main() {
  nums := []int{0, 6, 3, 4, 5, 7, 8, 9, 11}
  LIS(nums)
}

func LIS(nums []int) int {
  T := make([]int, len(nums))
  // Base case
  T[0] = 0

  for i := 0; i < len(nums); i++ {
    T[i] = 1
    for j := 0; j < i - 1; j++ {
      if nums[j] < nums[i] && T[i] < 1 + T[j] {
        T[i] = 1 + T[j]
      }
    }
  }
}
{{</highlight>}}

A few things to point out here:

* Line `11`: We set our base case as `T[0] = 0` because a string of length 0 
  has an LIS length of 0.
* Line `14`: During the _ith_ loop, we set the initial length in the table 
  `T[i] = 1` to accommodate the fact that we'll always, at the very least,
  have a length of 1, since our subsequence __must__ contain \\(a_i\\) (as defined
  in our subproblem definition)
* Line `15`: In this nested for loop, we're iterating between \\(0\\) and 
  \\(i - 1\\), which are all of the solutions to the LIS length problem
  up to \\(i-1\\).
* Lines `16-18`: Because we're searching for a suitable subsequence to attach
  the current character to, we check:
      * to ensure that \\(a_j < a_i \\)
      * to ensure that \\(T[i]\\) (the max length of a subsequence that includes
        \\(a_i\\)) is less than \\(1 + T[j]\\) because if the opposite were true,
        that would mean that \\(1 + T[j]\\) would not yield a max value.
      * If the above two conditions are met, we've found a previous solution
        that is suitable to append the current \\(a_i\\) to, which yields the
        length \\(1 + T[j]\\), which we assign on line `17`

# The Solution
Finding the answer to our problem in our solutions table is slightly different
than the Fibonacci problem, because we have to search for the greatest value.

The right-most solution in our table will simply be the length of the longest
increasing subsequence ending in that character, but finding the largest value
in the table will yield the longest increasing subsequence length across __all__
ending characters.
