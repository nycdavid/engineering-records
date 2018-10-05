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
