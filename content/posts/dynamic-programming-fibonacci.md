---
title: "Dynamic Programming Problem: Fibonacci sequence"
date: 2018-08-25
tags: ["algorithms", "dynamic programming", "fibonacci", "golang", "CS8803"]
draft: false
mathjax: true
meta_description: "We take a look at creating an efficient algorithm for solving
for the nth fibonacci number via dynamic programming."
---

# What is Dynamic Programming?
Dynamic programming in computer science is a method of solving a problem
by utilizing solutions to previous subproblems.

In order to do this, we must first:

1. Define a function that describes the problem we're attempting to solve
1. Define a base case
1. Define a recurrence relation
1. Write a procedure that models the recurrence

# The Steps

### 1. Problem definition
We want to define a procedure that calculates the nth fibonacci number. Mathematically: 

\\(Fib(n) = the\ nth\ number\ of\ the\ Fibonacci\ sequence\\)

### 2. Defining a base case
Like any problem with roots in induction, we must define a base case so we have
a point to start from. The base case here will be the first and second Fibonacci
numbers, or \\(Fib(0)\\) and \\(Fib(1)\\).

$$
Fib(0) = 0
\\\ Fib(1) = 1
$$

### 3. Defining a recurrence relation
It's here that we begin to see the problem take on a slightly inductive flavor.
What we now want to do here is to define the problem in __terms of a previous
problem__.

In the case of the Fibonacci sequence, this is straightforward. The method to
calculate the \\(nth\\) number is to add the previous number and the number
before that. Mathematically, this is defined as:

$$
Fib(n) = Fib(n-1) + Fib(n-2)
$$

### 4. Writing a procedure that models the recurrence relation
Now that we have our base case(s) and have defined our recurrence relation,
we're ready to write some code to make calculations.

#### The Table
Before we present the complete function, I'd like to mention a concept
that's called "the table". 

The table, in dynamic programming problems, is a __data structure__ that __stores
the solutions__ to previous subproblems. This is the __primary reason__ that 
dynamic programming algorithms are so much more efficient than their recursive 
counterparts. 

Rather than calculating the solutions to previous subproblems repeatedly 
(like recursive algorithms inefficiently do), we simply store each solution 
as it's calculated and then do a simple lookup when that solution is needed.

{{<highlight go "linenos=table, hl_lines=9-11">}}
package main

func main() {
  nth := 10
  Fib(nth)
}

func Fib(nth int) int {
  table := make([]int, nth+1)
  table[0] = 0
  table[1] = 1
}
{{</highlight>}}

In this case, assuming we want to get the 10th Fibonacci number, we allocate
memory for an __11 element slice__ (the base case plus Fibonacci numbers 1-10).
We also ensure that we pre-populate the zero'th and first Fibonacci numbers,
since we need them present as our base case.

We use the __index__ of the slice as the key to store its corresponding solution
(ex. the element at index `3` holds the 3rd Fibonacci number)

#### Looping
Now that we have our solutions table, we can write the rest of the Fib function:

{{<highlight go "linenos=table, hl_lines=13-16">}}
package main

func main() {
  nth := 10
  Fib(nth)
}

func Fib(nth int) int {
  table := make([]int, nth+1)
  table[0] = 0
  table[1] = 1

  for i := 2; i <= nth; i++ {
    table[i] = table[i-1] + table[i-2]
  }
  return table[nth]
}
{{</highlight>}}

What we're doing is iterating from `i = 2` (the first empty position) to `i = 10` 
(the Fibonacci number we're attempting to solve for). As we calculate each one,
we store it in the table and when the `for` loop completes, we return the
the last element of the array, our `nth` Fibonacci number.
