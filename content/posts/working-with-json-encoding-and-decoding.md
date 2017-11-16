---
title: "Working with JSON: Encoding & Decoding"
date: 2017-11-26
tags: ["go", "json", "streams"]
draft: false
---

In my previous blog post on working with JSON, I wrote about the basics of
marshaling and unmarshaling existing Go types into their JSON string
counter parts.

Today, we're going to learn about __encoding__ and __decoding__ in JSON,
something that's done when the source or destination is one end of a stream
of data, that implement the __Reader__ and __Writer__ interfaces in Go.

I've found that understanding Encoding and Decoding is, typically, a bit more
difficult than standard marshaling/unmarshaling, because there are several
steps that need to be executed prior to actually handling the JSON, but I'll
do my best to provide a detailed and easy-to-understand explanation in the
paragraphs that follow.

---

## Encoding JSON

Before we get into working with the actual encoding function, it's best that
we do a simple and brief primer on Go's `io.Writer` interface. If you're asking
yourself why, we'll find out shortly!

You'll know (covered in [my article on interfaces](https://blog.velvetreactor.com/posts/using-interfaces-for-flexibility/)))
that an interface is a mechanism by which Go enforces duck typing and requires
that a type implement specific methods in order for it to be used in functions
that require that interface.

The `io.Writer` interface is one that requires a type have the `Write` method
on it with the following method signature:

```go
type Writer interface {
  Write(p []byte) (n int, err error)
}
```

Therefore, if any type implements the `Write` method with the specific argument
and return types outlined above, that type is said to __implement the Writer
interface__.

Why is this important? Because, the `json.NewEncoder` function by which we
create an encoder that writes a JSON string, requires that we pass it a type
that conforms to the `io.Writer` interface:

```go
func NewEncoder(w io.Writer) *Encoder
```

---

So, what's `json.NewEncoder` really asking for, in layman's terms? In order to
better understand that, I've found that it helps to think of it in the following
steps:

* We want to encode a JSON string, i.e. we want to take some Go primitive and
  translate it to JSON.
* We need a data stream to write it to, like a buffer.
* We can't simply pass it a buffer because it has no entry point without
  `io.Writer`'s `Write` method.

Thus, we have to create a buffer (area in memory) for the JSON string to be
stored, as well as some sort of seam by which data can be written to the buffer.

We'll be seeing how to do that in the following code example:

```go
import (
  "bytes"
  "encoding/json"
  "fmt"
)

type Person struct {
  Name string
  Age int
}

func main() {
  var buf bytes.Buffer
  p1 := Person{
    Name: "David",
    Age: 29,
  }
}
```

The first thing we'll do here is create a variable of the `bytes.Buffer` type,
to store our JSON string. As can be read in the documentation, `bytes.Buffer`
has both the `Read` and `Write` method. Then, we create an instance of the
Person type and give it data like `Name` and `Age`.

```go
import (
  "bytes"
  "encoding/json"
  "fmt"
)

type Person struct {
  Name string
  Age int
}

func main() {
  var buf bytes.Buffer
  p1 := Person{
    Name: "David",
    Age: 29,
  }
  enc := json.NewEncoder(&buf)
}
```

We now call `json.NewEncoder` and pass it a pointer to our `buf` variable.
It happily accepts it because, as we read earlier, it has the `Write` method,
thereby implementing the `io.Writer` interface.

```go
import (
  "bytes"
  "encoding/json"
  "fmt"
)

type Person struct {
  Name string
  Age int
}

func main() {
  var buf bytes.Buffer
  p1 := Person{
    Name: "David",
    Age: 29,
  }
  enc := json.NewEncoder(&buf)
  enc.Encode(p1)

  fmt.Println(buf.String())

  //=> {"Name":"David","Age":20}
}
```

Finally, we tell it to encode the `p1` variable which is the Person we created,
and then print the data held in `buf` out to the command line, which we can see
is the JSON representation of the `p1` variable.

It's also worthwhile to note, that by using struct tags, we would have been able
to encode the data with whatever keys we wanted, if the `Name` and `Age` keys
weren't appropriate.

## Decoding JSON
Once we understand the `io.Writer` interface, the `io.Reader` interface is a
very similar concept but for reading data from a data stream rather than writing
data to one. Thus, it can be thought of as a spout by which we pull data out of
a buffer.

Similar to how `io.Writer` requires the `Write` method, `io.Reader` requires the
`Read` method:

```go
type Reader interface {
  Read(p []byte) (n int, err error)
}
```

Let's try creating an analog to the encoding example, but using decoding instead.

```go
import (
  "bytes"
  "encoding/json"
  "fmt"
)

type Person struct {
  Name string
  Age int
}

func main() {
  var p1 Person
  jsonStr := `{"Name": "David", "Age": 29}`
  buf := bytes.NewBufferString(jsonStr)
}
```

Here, we start with a JSON string and create a buffer to hold it. We also create
and empty `p1` variable of the type `Person`, which is going to hold the data
that we decode from the buffer.

```go
import (
  "bytes"
  "encoding/json"
  "fmt"
)

type Person struct {
  Name string
  Age int
}

func main() {
  var p1 Person
  jsonStr := `{"Name": "David", "Age": 29}`
  buf := bytes.NewBufferString(jsonStr)

  dec := json.NewDecoder(buf)
}
```

After that, we create a new decoder using the `json.NewDecoder` function, but
this time the buffer that we provide it with as an argument is where it's
going to __read__ from when it's time to decode.

```go
import (
  "bytes"
  "encoding/json"
  "fmt"
)

type Person struct {
  Name string
  Age int
}

func main() {
  var p1 Person
  jsonStr := `{"Name": "David", "Age": 29}`
  buf := bytes.NewBufferString(jsonStr)

  dec := json.NewDecoder(buf)
  dec.Decode(&p1)

  fmt.Println(p1.Name)
  //=> David
  fmt.Println(p1.Age)
  //=> 29
}
```

Finally, we call `decode` and pass in a pointer to the earlier declared `p1`
variable and we can see that it has successfully decoded the attributes into
the struct fields for which they were meant.

## Real-world Example: HTTP Server
In this example, we're going to look at a very common situation in which we'd
need to use JSON in data stream form: writing the body of an HTTP response.

Let's start by creating a super simple HTTP server:

```go
package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type Person struct {
	Name string
	Age  int
}

func JsonRoute(w http.ResponseWriter, req *http.Request) {
  // TBD
}

func main() {
	http.HandleFunc("/", JsonRoute)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
```

As we can see above, the server has one route located at the root and handled
by the function `JsonRoute`. Let's take a look at the code we'd have to add to
the body of the `JsonRoute` function to get a JSON string.

```go
func JsonRoute(w http.ResponseWriter, req *http.Request) {
  p1 := Person{
		Name: "David",
		Age:  29,
	}
	enc := json.NewEncoder(w)
	enc.Encode(&p1)
}
```

Inside the function, we now create a new instance of the `Person` type with our
desired attributes. Because we're intending to *send* rather than *receive*
JSON, we want to __encode__ the struct.

When we call `json.NewEncoder`, we pass in an instance of `http.ResponseWriter`
which is a type that implements the `io.Writer` interface (exactly what
`NewEncoder` requires).

Finally, we call `Encode` and pass it a pointer to the struct we created earlier
as an argument. When we start the server and visit the root route, we can see
that, just as we expected, we get the JSON string representation of the `p1`
variable.

---

Hopefully that was an easy to follow introduction to JSON encoding/decoding
methods and how they fit into real world examples using streams.

Let me know what you you thought in the comments below!
