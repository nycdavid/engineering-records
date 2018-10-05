---
title: "Matrix Multiplication & Associated Cost"
date: 2018-10-01
tags: ["algorithms", "dynamic programming", "golang", "CS8803", "chain matrix multiplication", "fundamentals"]
draft: false
mathjax: true
meta_description: "Fundamentals of matrix multiplication"
---

Below will be a quick review of how to multiply matrices. Let's say we have the 
following matrices \\(A\\), \\(B\\) and \\(C\\):

$$
A =
  \begin{bmatrix}
    1 & 2 & 3 \\\\\
    4 & 5 & 6 \\\\\
    7 & 8 & 9
  \end{bmatrix} \qquad
B =
  \begin{bmatrix}
    5 & 6 \\\\\
    7 & 8 \\\\\
    9 & 10
  \end{bmatrix} \\qquad
C =
  \begin{bmatrix}
    11 & 12 \\\\\
    13 & 14
  \end{bmatrix}
$$

The rules of multiplication are:

1. When multiplying matrices \\(m_1 \times m_2\\), the numbers of columns of \\(m_1\\) 
  (\\(m\_{1_c}\\)) __must match__ the numbers of rows in \\(m_2\\) (\\(m\_{2_r}\\))
    * \\(m\_{1_c} = m\_{2_r}\\)
1. The dimensions of the resulting product of the two matrices, \\(m_3\\), will be 
  \\(m\_{1_r} \times m\_{2_c}\\)
    * \\( 
        \begin{bmatrix}
          a\_{11} & a\_{12} \\\\\
          a\_{21} & a\_{22} \\\\\
          a\_{31} & a\_{32}  
        \end{bmatrix}
        \times
        \begin{bmatrix}
          b\_{11} & b\_{12} \\\\\
          b\_{21} & b\_{22} \\\\\
        \end{bmatrix}
        =
        \begin{bmatrix}
          a\_{11} \cdot b\_{11} + a\_{12} \cdot b\_{21} & a\_{11} \cdot b\_{12} + a\_{12} \cdot b\_{22} \\\\\
          a\_{21} \cdot b\_{11} + a\_{22} \cdot b\_{21} & a\_{21} \cdot b\_{12} + a\_{22} \cdot b\_{22} \\\\\
          a\_{31} \cdot b\_{11} + a\_{32} \cdot a\_{21} & a\_{31} \cdot b\_{12} + a\_{32} \cdot b\_{22}
        \end{bmatrix}
      \\)

From the above rules, we can infer the following:

* Matrix \\(A\\) has 3 columns while matrix \\(B\\) has 3 rows, therefore, 
  \\(A \times B\\) would be a valid matrix multiplication operation. 
* \\(A \times C\\), however, would not be, since \\(C\\) only has two rows.

# The Cost of Matrix Multiplication
If we had 4 matrices, \\(A, B, C\\) and \\(D\\), and wanted to calculate their product, 
\\(A \times B \times C \times D\\), how many different ways could we do it?

* \\((A \times (B \times C)) \times D\\)
* \\(((A \times B) \times C) \times D\\)
* \\(A \times (B \times (C \times D))\\)
* \\((A \times B) \times (C \times D)\\)

The question that we'll try to answer in this section is: how do we analyze the 
operations __cost__?

How would we figure out how many operations a given matrix multiplication would cost?
Let's take a look at an example problem:

$$
A =
  \begin{bmatrix}
    a\_{11} & a\_{12} & \cdots & a\_{1c} \\\\\
    \vdots & \vdots & \ddots & \vdots \\\\\
    a\_{r1} & a\_{r2} & \cdots & a\_{rc}
  \end{bmatrix} \qquad
B =
  \begin{bmatrix}
    b\_{11} & \cdots & b\_{1c} \\\\\
    b\_{21} & \cdots & b\_{2c} \\\\\ 
    \vdots & \ddots & \vdots \\\\\
    b\_{r1} & \cdots & b\_{rc}
  \end{bmatrix}
$$

Let's first determine the general form of how to figure out the inner product of 
a given row and column of \\(A\\) and \\(B\\). 

Assuming that our resulting matrix will be called \\(C\\), we can calculate the
entry \\(c\_{ij}\\) with the following:

$$
c\_{ij} = \sum\_{k=1}^{A_c} a\_{ik} \cdot b\_{kj}
$$

Before we proceed, let's unpack and explain the above summation a bit:

* \\(c\_{ij}\\): We are attempting to calculate the value at the \\(ith\\) row 
  and \\(jth\\) column of the product matrix
* \\(\sum\_{k=1}^{A_c}\\): iterate \\(A_c\\) (number of columns in A) times, 
  increasing \\(k\\) by 1 each time, and sum the results.
* \\(a\_{ik} \cdot b\_{kj}\\): find the value located at row \\(i\\), column \\(k\\)
  in matrix \\(A\\) and multiply it with the value located at row \\(k\\), 
  column \\(j\\) in matrix \\(B\\).

Looking at an example where we calculate \\(c\_{33}\\) of two matrices, the 
expansion would look like this:

$$
\begin{align}
  c\_{33} &= \sum\_{k=1}^{3} a\_{3k} \cdot b\_{k3} \nonumber \\\\\
  &= a\_{31} \cdot b\_{13} + a\_{32} \cdot b\_{23} + a\_{33} \cdot b\_{33} \nonumber
\end{align}
$$

So how many operations are we looking at to calculate the above?

* Additions:
    * For each combination of row and column, we'd need to do \\(A_c-1\\) additions
    * This would happen \\(A_r\\) times, thus
    * To calculate the multiplication of \\(A \times B\\), we'd need to execute
      \\((A_c-1) \cdot A_r\\) addition operations
* Multiplications:
    * For each combination of row and column, we'd need to do \\(A_c\\) multiplications
    * which would also happen \\(A_r\\) times
    * To calculate the multiplication of \\(A \times B\\), we'd need to execute 
      \\(A_c \cdot A_r\\) multiplication operations.
