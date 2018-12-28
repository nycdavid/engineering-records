---
title: "Birrell's Sync Primitives: Condition Variables"
date: 2018-12-28
tags: ["os", "concurrency", "condition variables", "threads"]
draft: false
meta_description: "We go through another mechanism by which we can synchronize the
execution of threads: condition variables."
---

Sometimes we want a thread to block its execution until some predicate value 
evaluates to `true`, at which point we'd want it to then continue.

Our first instinct may be to implement a `while` loop to check on the value
and skip until it returns `true`. 

{{<highlight c "linenos=true">}}
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

int done = 0;

void *setDone(void *a) {
  sleep(3);
  done = 1;
  return NULL;
}

int main() {
  pthread_t child;
  pthread_create(&child, NULL, setDone, NULL);

  while (done == 0) {
    printf("Sleeping...\n");
    sleep(1);
  }
  printf("Done. Exiting...\n");
  return 0;
}
{{</highlight>}}

This would be very wasteful, however, because we'd be keeping the thread alive as 
well as using up CPU cycles to continuously check the variable of interest. 

![An inefficient while loop](https://i.imgur.com/RdtAJLe.png)

As we can see, the `while` loop keeps grinding away until the `done` variable evaluates
to `true`, requiring CPU cycles to do so.

It would be __much__ more efficient to simply have the thread rest until it receives a
signal that the variable of interest has changed and that it should resume execution.

### Reimplementing with a condition variable

We can think of condition variables as a channel on which a resting (paused) thread 
can listen to so that it can be awoken at a later time to continue execution.

Before we continue, we have to familiarize ourselves with several components from the
`<pthread.h>` library:

* `pthread_cond_t`: the opaque type for a POSIX condition variable
* `pthread_cond_wait(*pthread_cond_t, *pthread_mutex_t)`: method to put the calling 
  thread to sleep. Accepts a condition variable that it listens on and a mutex 
  (that it releases).
* `pthread_cond_signal(*pthread_cond_t)`: Sends a signal to awaken the thread(s)
  listening on the condition variable.

With the above constructs, we can rewrite the above looping implementation to instead
use condition variables:

{{<highlight c "linenos=true">}}
#include <stdio.h>
#include <pthread.h>

int done = 0;
pthread_cond_t c = PTHREAD_COND_INITIALIZER;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;

void *signal(void *a) {
  pthread_mutex_lock(&m);
  done = 1;
  pthread_cond_signal(&c);
  pthread_mutex_unlock(&m);
  return NULL;
}

int main() {
  printf("Main thread.\n");
  pthread_t p;
  pthread_create(&p, NULL, signal, NULL);

  pthread_mutex_lock(&m);
  while (done == 0) {
    pthread_cond_wait(&c, &m);
  }
  pthread_mutex_unlock(&m);
}
{{</highlight>}}

The main thread here:

* Initializes the thread variable `p` and associates it with the `signal` function.
* It then acquires the mutex (because we're about to read/write the variable of
  interest `done`)
* If `done` is still `0`, we call `pthread_cond_wait()`, which pauses the invoking
  thread, releases the mutex given to it and waits on the condition variable passed
  to it.

The secondary thread created (the one invoking `signal`):

* Acquires the mutex (because we're about to read/write to `done`)
* Assigns `1` to the `done` variable
* Signals on the condition variable that the variable of interest has changed
  (with `pthread_cond_signal`)
* Releases the mutex

### Lingering Questions

There are still a few questions to be answered with regards to the current
implementation that I found curious:

* Why does the main thread have to have a `while` loop checking the `done` 
  variable?
* What if we didn't use a `done` variable at all? Isn't it enough to acquire
  the mutex and have the main thread wait for the signal?
