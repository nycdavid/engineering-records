---
title: "process.nextTick in nodejs and starvation"
date: 2018-01-27
tags: ["javascript", "nodejs", "event loop", "process.nextTick", "starvation"]
draft: false
meta_description: "In this post, we take a look at the process.nextTick function
in nodejs and how it effects the running of the event loop. We also examine the
risk of starvation when using process.nextTick"
---

Today, we're going to study the `process.nextTick` function call and how it effects
the running of the event loop. We'll also analyze the Computer Science concept
of __starvation__ and how it relates to Javascript's event loop.

# Starvation and Priority Queues
To understand what `process.nextTick` is capable of, we first have to take a detour
into understanding what a __queue__ is and how it works.

A __queue__ is an abstract data type (ADT), usually implemented by an array or
a linked list, that is mostly used for __first in, first out__ (FIFO) item processing.

This can be understood by likening a queue to a line at a fast-food restaurant:
the first customer to stand on line is the first customer to have their order
taken. Once their order is taken (i.e. processed), they step off of the line and
move to the area in which they receive their order.

![Depiction of a Queue processing items on a FIFO basis](https://i.imgur.com/NUHdHof.png)

Sometimes, however, a simple, FIFO queue may not be what we need, as all jobs
are not created equal. Some jobs, like urgent or time-sensitive ones, may carry
a higher priority than your average, run-of-the-mill task. For these, we can use
__priority queues__.

Priority queues can be thought of as two (or more) lines with differing importance
assigned to each line. The higher priority line(s) are processed before the lower
priority lines, again on a first in, first out basis.

![High & Low Priority Queues](https://i.imgur.com/eUUl8ee.png)

Assuming that there exists only a single entity for processing, (like a single thread),
for as long as the high priority queue is empty, the low priority queue's items
will get processed, but as soon as an item enters the high priority queue, attention
is immediately given to it by the processor.

This is where the idea of __starvation__ can happen. Starvation is when items
continuously enqueue into a higher priority queue at a frequency such that a
lower priority queue's items can __never get processed__.

![Priority Queue Starvation](https://i.imgur.com/j2TTurn.png)

# Event Loop: A Phases Overview
The event loop in Javascript environments is an oft misunderstood part of the
running of a Javascript program. This is mostly because there's so little visibility
into how the event loop actually works.

This won't be an article that analyzes the minutiae of the event loop, but we will
give the __phases of the event loop__ a glance, as we talk about the different
functions that execute in the different parts of the event loop.

---

There are several phases that the event loop makes it's way through on every
iteration of the loop. We're going to focus on timer callbacks today because of
the fact that they occur first.

Below is a list of phases that occur during the event loop, according to the
[nodejs website](https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/):

* timers
* I/O callbacks
* idle, prepare
* poll
* check
* close callbacks

When the event loop enters the timer phase, the node engine checks to see if any
timers have expired. If it finds expired timers, it requests that the OS kernel
__schedule the callback associated with that timer__.

Once those callbacks have been executed, the phase is considered to be completed
and the event loop moves on to the next phase.

`process.nextTick` is a function that accepts a callback as a parameter and then
schedules that callback to execute __immediately after current operation has
completed__.

Thus, if we were to call `process.nextTick` inside of an asynchronous action,
it would halt current execution of the callback and execute the `nextTick` callback.
In that way, the `nextTickQueue` is actually behaving like a __priority queue__.

Just like how we mentioned above that a __priority queue__ can have the side effect
of causing starvation if not properly managed, `process.nextTick` can cause the
same issue, sometimes preventing other callbacks further along the line of the
event loop from executing.

What we're doing here is:

* Reading a file with the `fs` package, and executing a `console.log` in the callback.
* Setting a `setTimeout` to 0 ms and calling nested `process.nextTick`s inside of the callback, all spaced out by 3 seconds each.

And let's see what happens when this code is evaluated:

![executing process.nextTick with blocking code](https://i.imgur.com/vTZWGuw.gif)
