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

Enforcing that \\(A_i\\) has dimensions \\(m\_{i-1} \times m_i\\) allows us to
predictably generate dimensions for the \\(ith\\) matrix while ensuring that
its dimensions will be "multiplicatively valid" with the matrix that comes
after it.

# The Subproblem Definition
Typically, we would craft our subproblem such that we consider prefixes, like "minimum
cost from \\(A_1\\) to \\(A_i\\) where \\(i \leq n\\)". 

Instead, we'll find it much more suitable and complete to consider __substrings__ of 
\\(A_1 \times A_2 \times \cdots \times A_n\\) where we consider \\(A_i\\) through \\(A_j\\)
and where \\(1 \leq i \leq j \leq n\\).

Let's take a look at the binary tree representation of a matrix multiplication problem, 
as that will help us visualize the tactics that we're about to use.

![Binary tree representation of chain matrix multiplication](https://imgur.com/ENGTWcy.png)

We can see that every pair of child nodes is actually a term in the multiplication
operation that produces their parent node. 

For example, if we multiply the child nodes \\((2)\\) and \\((3)\\) together, we 
will get our root node \\((1)\\) (their parent).

Thus, our subproblem definition, formally stated, is:

$$
C(i, j) = \text{the minimum cost of calculating } A_i \times A\_{i+1} \times 
\cdots \times A_j
$$

# The Recurrence Relation
Let's determine the base case for \\(C(i, j)\\): at first glance we may want to
conclude that there's a single base case \\(C(0, 0) = 0\\) because if \\(i = j = 0\\),
then we are starting and ending with a single matrix (i.e. there's no multiplication
work to be done).

But is this not the case for __all__ situations in which \\(i = j\\)? Indeed it is,
because even if \\(i = j = 100\\), we'd only be dealing with a single matrix
\\(A\_{100}\\) and, again, there would be no work to do.

So if our two-dimensional solutions table were to have the base cases filled in,
it would contain zeros all along its diagonal
(\\(A\_{11} = A\_{22} = \ldots = A\_{nn} = 0\\))

$$
C = 
\begin{bmatrix}
  0 & c\_{12} & \cdots & c\_{1n} \\\\\\
  c\_{21} & 0 & \cdots & c\_{2n} \\\\\\
  \vdots & \vdots & \ddots & \vdots \\\\\\
  c\_{n1} & c\_{n2} & \cdots & 0
\end{bmatrix}
$$

Furthermore, because we're only interested in the cases where \\(i \leq j\\), the only
area of \\(C\\) that is relevant are the cells __to the right__ of the diagonal.

---

Now, in order to define \\(C(i, j)\\) in terms of earlier subproblems, let's
look at the binary tree of \\(A_1 \times \cdots \times A_n\\) that's split at some 
arbitrary point \\(l \leq n\\)

![Multiplication problem split at l](https://imgur.com/934wx5e.png)

> What would be the size of the product at the root node \\((1)\\) of
  \\(A_1 \times \cdots \times A_n\\)?

In order to determine the cost of the root node, we can calculate the work required 
to multiply the root's two child nodes. Let's calculate the size of each to get that:

* \\(A_1 \times \cdots \times A_l\\): the size of this resulting matrix winds up being 
  \\(A\_{1_r} \times A\_{l_c}\\) 
  ([why?](/posts/fundamentals-matrix-multiplication#size-of-the-product))
* \\(A\_{l+1} \times \cdots \times A_n\\): this size would be 
  \\(A\_{l+1_r} \times A\_{n_c}\\) 
* Finally, the work required would be: \\(A\_{1_r} \cdot A\_{l_c} \cdot A\_{n_c}\\)
