---
title: "Chain Matrix Multiplication"
date: 2018-10-04
tags: ["algorithms", "dynamic programming", "golang", "CS8803", "chain matrix multiplication", "optimization"]
draft: false
mathjax: true
meta_description: "Creating a dynamic programming algorithm for solving the chain matrix mulitplication 
min cost problem"
---

In this post, we'll attempt to solve the cost minimization problem for chain matrix
multiplication. 

Please make sure you're familiar with 
[matrix multiplication and analyzing operations cost]
(/posts/fundamentals-matrix-multiplication/) before proceeding.

# The Problem
The question we're asking ourselves with this problem is:

> For \\(n\\) matrices \\(A_1, A_2,\ldots,A_n\\), where \\(A_i\\) has dimensions
  \\(m\_{i-1} \times m_i\\), __what is the minimum cost for computing 
  \\(A_1 \times A_2 \times \cdots \times A_n\\)?__

Before proceeding, let's make sure to understand why \\(A_i\\) (a given matrix in 
the chain) is said to have dimensions \\(m\_{i-1} \times m_i\\).

This __must__ be the case for any two operands in a multiplication operation in
the chain. For instance, when it comes time to perform \\(A_1 \times A_2\\), if
\\(A_1\\) has dimensions \\(m_0 \times m_1\\), then \\(A_2\\)'s rows __must__
equal \\(m_1\\). 

We have to have a formulaic way of determining the dimensions of each term, hence 
the requirement that the dimensions of any given matrix must be 
\\(m\_{i-1} \times m_i\\),

Because we know that the dimensions of the operands are the only variable that
influences operation cost, we can see that: 

* __Inputs__: the sizes \\(m_0, m_1, \ldots, m_n\\)
* __Goal__: finding minimum cost of computing \\(A_1 \times A_2 \times \cdots \times A_n\\)

# The Subproblem Definition
Let's define it as follows:

$$
C(i) = \text{minimum cost for computing } A_1 \times A_2 \times \cdots \times A_n
$$

Let's also take a look at this matrix multiplication problem in the form of a
binary tree, as that will help us visualize the tactics that we're about to use.

![Binary tree representation of chain matrix multiplication](https://imgur.com/ENGTWcy.png)

We can see that every pair of child nodes is actually a term in the multiplication
operation that produces their parent node. 

For example, if we multiply the child nodes \\((2)\\) and \\((3)\\) together, we 
will get our root node \\((1)\\) (their parent).

> A __substring__ of a string is a prefix of a suffix or, equivalently, a suffix 
  of a prefix.
