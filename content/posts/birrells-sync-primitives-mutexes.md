---
title: "Birrell's Sync Primitives: Mutexes"
date: 2018-12-20
tags: ["os", "concurrency", "mutexes", "threads"]
draft: false
meta_description: "We discuss a common problem when writing concurrent code:
corruption that can occur when independent threads read and modify a shared data
structure and how a mutex can be used to solve this problem."
---

If we were to explain, in a very basic way, how a simple Golang or C program
runs, we could say that it executes the statements, in order, from top to bottom.

Let's consider the following:

{{<highlight c "linenos=true">}}
#include <stdio.h>

int main() {
  printf("1");
  printf("2");
  printf("3");
  return 0;
}
{{</highlight>}}

This would execute in the shell in much the way that one would expect:

![Basic C program](https://i.imgur.com/3gRSZZ7.png)

### Autonomous Threads

It becomes a bit more complicated when we have several concurrent threads
that invoke `printf()` instead. These child threads will splinter off their
parent (the main thread) and execute autonomously, making the `printf`
statements completely unpredictable.

{{<highlight c>}}
#include <stdio.h>
#include <pthread.h>

void *printout(void *input) {
  printf("%d\n", *(int*)input);
  return NULL;
}

int main() {
  pthread_t a;
  pthread_t b;
  pthread_t c;

  int one = 1;
  int two = 2;
  int three = 3;

  pthread_create(&a, NULL, printout, &one);
  pthread_create(&b, NULL, printout, &two);
  pthread_create(&c, NULL, printout, &three);

  pthread_join(a, NULL);
  pthread_join(b, NULL);
  pthread_join(c, NULL);

  return 0;
}
{{</highlight>}}

![Example of concurrent printing](https://i.imgur.com/X3C9Dml.png)

As we can see, the printing of the integers is inconsistent because each thread
is executing independently.

### Data Corruption

What happens when we start using threads to __read__ and __write__ some shared
data or resource?

{{<highlight c "linenos=true">}}
#include <stdio.h>
#include <pthread.h>

int counter = 0;

void *increment(void *a) {
  int projected = counter + 1;
  printf("[ID: %d] Projected: %d.\n", *(int*)a, projected);
  counter = counter + 1;
  printf("[ID: %d] Actual: %d.\n", *(int*)a, counter);
  return NULL;
}

int main() {
  pthread_t thrd_a;
  pthread_t thrd_b;
  pthread_t thrd_c;

  pthread_create(&thrd_a, NULL, increment, &thrd_a);
  pthread_create(&thrd_b, NULL, increment, &thrd_b);
  pthread_create(&thrd_c, NULL, increment, &thrd_c);

  pthread_join(thrd_a, NULL);
  pthread_join(thrd_b, NULL);
  pthread_join(thrd_c, NULL);

  return 0;
}
{{</highlight>}}

A few things to note here:

* On line 4, we declare a global variable, `counter`. This will be the
  shared resource that we mutate across threads.
* The `increment()` function reads from the `counter` variable and first
  prints a _projected_ value, meaning the value that it _thinks_ will
  be the new value after incrementing it by 1.
* The thread ID precedes each projected and actual log statement in order
  to identify the threads in the shell.

Let's see what the executed program actually prints:

![Concurrent code without mutex](https://i.imgur.com/vMWlx8B.png)

All three threads in this programs projected the new value of `counter` to be
1, but when printing the actual value after incrementation, we can see that
they were incorrect.

Here's what's happening:

1. All 3 threads read the `counter` variable as `0` (since that's the value it
  was initially assigned)
2. Every thread's projected value is then calculated as 1.
3. Each thread then increments the value of `counter` and reads a newly incremented
  value as it's _actual_ value.

How do we prevent such inconsistencies?

### Mutexes

In order to deal with this properly, most modern languages have implemented a
construct called a __mutex__.

A mutex (short for mutual exclusion) provides the ability to lock certain
__critical sections__ of code from being executed by more than one thread
at a time.

Let's modify our code to start using mutexes to synchronize our threads:

{{<highlight c "linenos=true, hl_lines=7 10 15">}}
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

int counter = 0;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void *increment(void *a) {
  pthread_mutex_lock(&lock);
  int projected = counter + 1;
  printf("[ID: %d] Projected: %d.\n", *(int*)a, projected);
  counter = counter + 1;
  printf("[ID: %d] Actual: %d.\n", *(int*)a, counter);
  pthread_mutex_unlock(&lock);
  return NULL;
}

int main() {
  pthread_t thrd_a;
  pthread_t thrd_b;
  pthread_t thrd_c;

  pthread_create(&thrd_a, NULL, increment, &thrd_a);
  pthread_create(&thrd_b, NULL, increment, &thrd_b);
  pthread_create(&thrd_c, NULL, increment, &thrd_c);

  pthread_join(thrd_a, NULL);
  pthread_join(thrd_b, NULL);
  pthread_join(thrd_c, NULL);

  return 0;
}
{{</highlight>}}

A few things to note:

* Line 7: initializes a variable `lock` of type `pthread_mutex_t` and is
  assigned `PTHREAD_MUTEX_INITIALIZER`
* Line 10: we attempt to acquire the mutex as the first statement in the
  `increment()` function (note that the thread will block and wait at this
  point if the mutex has already been acquired by another thread)
* Line 15: after `increment()` has executed, a call to `pthread_mutex_unlock()`
  releases the mutex and makes it available for other threads

Running the code yields the following output:

![Code running with mutexes](https://i.imgur.com/Yl7MjgH.png)

As we can see from running the code repeatedly, although the order of the
thread ids can change, depending on which thread is able to acquire the mutex
first, there is never a discrepancy between what the projected value is
and what the actual value is because both read and write operations are contained
within the __critical section__ of the mutex.


