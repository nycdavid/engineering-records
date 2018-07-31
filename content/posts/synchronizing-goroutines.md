---
title: "Synchronizing Goroutines with sync.WaitGroup"
date: 2018-02-05
tags: ["concurrency", "golang", "sync", "goroutines"]
draft: false
meta_description: "In this post, we look at the goroutines and synchronizing them with
a WaitGroup"
---

The `sync` package has lots of great utilities for wrangling concurrent code. One very
useful struct in this package is `WaitGroup`.

`WaitGroup` allows us to increment and decrement a counter according to how many
goroutines we have running in threads other than the main one. Let's take a look at
a problem that `WaitGroup` helps solve for us:

# Exiting before completion
A common issue that programmers may run into when initially playing with concurrency 
is a program exiting before all functions have completed executing.

```go
package main

import (
	"fmt"
)

func main() {
	fmt.Println("Beginning")

	go func() {
		fmt.Println("Middle")
	}()

	fmt.Println("End")
}
```

Let's see what gets output when this code is executed:

![Code demonstration]()

As you can see, __Beginning__ and __End__ get printed, but the program exits before the
"Middle" goroutine has had a chance to execute. We can use `sync.WaitGroup` to prevent
this from happening.

# Waiting for Goroutines to finish

The `sync.WaitGroup` construct has 3 methods that we're going to be looking at today. They
are:

* `func(wg *sync.WaitGroup) Add(delta int)`
* `func(wg *sync.WaitGroup) Done()`
* `func(wg *sync.WaitGroup) Wait()`

It makes the most sense to start with the `Wait()` function. Invoking `Wait()` 
in the main goroutine will block execution until the counter inside of the 
`WaitGroup` drops to zero.

Influencing the counter within a `WaitGroup` is what will allow us to wait until all 
goroutines in a program have completed execution before allowing the main thread
of a program to exit and using the functions `Add(delta int)` and `Done()` are
what allow us to do so.

`Add(delta int)` will increment the counter within `WaitGroup` by the `delta` amount
and should be invoked every time a goroutine is started to represent the number of
currently executing threads in a program.

`Done()` will decrement the counter in `WaitGroup` and should be the last line in
a goroutine, to be invoked when a function has completed its work. Note that `Done()`
is functionally equivalent to invoking `Add(-1)`.

```go
import (
	"fmt"
	"sync"
)

func main() {
	var wg sync.WaitGroup

	fmt.Println("Beginning")

	wg.Add(1)
	go func() {
		fmt.Println("Middle")
		wg.Done()
	}()

	wg.Wait()
	fmt.Println("End")
}
```

The above code is nearly identical to the first with a few key differences:

* We initialize a `sync.WaitGroup` on the first line of `main()`
* We invoke `wg.Add(1)` prior to invoking `go func()`
* We add a `wg.Done()` call to the end of our goroutine
* Finally, we add a `wg.Wait()` call toward the end of our `main()` function to 
	block the main thread until all goroutines have completed execution
