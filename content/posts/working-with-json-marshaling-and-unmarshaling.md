---
title: "json - Marshaling & Unmarshaling"
date: 2017-11-19
tags: ["go", "json"]
draft: false
meta_description: "Learn how to convert JSON to a struct in Golang by using Unmarshaling. Also learn how to convert a struct into JSON with Marshaling."
---

Every software engineer working in web application development has had to deal
with JSON at one point or another. It's all over the place now! But handling it
in Go can be somewhat daunting, especially if someone is coming from Ruby or
JavaScript, where the JSON parsing/serializing is *very* simple.

---

For the most part, there are __two ways__ to deal with JSON in Go that I'll be
diving into for this and subsequent blog posts:

* Marshaling & Unmarshaling
* Encoding & Decoding

The key to deciding which method you end up using in your program depends
largely on *what form the data is in* when you're starting out with it. What
I mean by that is: is the data you want to convert to and from JSON in __stream__
form? Or is it a Go primitive that's already been read into memory?

I'll be diving into Marshaling & Unmarshaling with this post, while my next
post will deal with encoding & decoding.

## Marshaling

You'd want to use Marshaling in your code when you've got some Go primitives
in memory (that were probably created during the execution of your program) and
you to convert them into a JSON string.

For example, let's say you've got some structs or some slices you want to
convert to a JSON string to be passed around to other spots in your app.

```go
package main

type Person struct {
  Name string
  Age int
}

func main() {
  me := Person{
    Name: "David",
    Age: 29,
  }
}
```

We could easily call `json.Marshal` on the `me` variable (a `Person` struct)
and marshal it into a JSON string that can be printed to output with
`fmt.Println`.

```go
package main

type Person struct {
  Name string
  Age int
}

func main() {
  me := Person{
    Name: "David",
    Age: 29,
  }
  bits, _ := json.Marshal(me)
  fmt.Println(string(bits))
}

//=> {"Name":"David","Age":29}
```

## Unmarshaling

Unmarshaling can be thought of as doing the inverse of Marshaling. It takes
a JSON string byte slice and maps it back to a Go primitive data type, like a
slice, struct or array. As such, it receives two arguments:

  * The byte slice version of the JSON string
  * A pointer to the "object" that it's mapping the JSON string to

```go
// from the Golang documentation
func Unmarshal(data []byte, v interface{}) error
```

Let's see a code example of what that looks like:

```go
  import (
    "fmt"
    "encoding/json"
  )

  type Person struct {
    Name string // Make sure these attributes are capital letters
    Age int     // The JSON unmarshaling won't work correct if they aren't
  }

  func main() {
    sampleJsonObj := `{"name": "David", "age": 29}`
  	var person1 Person
    sampleJsonObjBytes := []byte(sampleJsonObj)
  	json.Unmarshal(sampleJsonObjBytes, &person1)

  	fmt.Println(fmt.Sprintf("My name is: %s", person1.Name))

    //=> My name is: David
  }
```

In the above snippet, we:

1. declare a JSON string (wrapped in backticks) and assign it to `sampleJsonObj`.
1. We declare a `person1` variable of the `Person` type.
1. __Convert the string__ into a slice of bytes because that's the type the
  `Unmarshal` function expects.
1. Finally, we call `json.Unmarshal` with the byte slice and a pointer to the
  initialized `person1` variable as arguments, respectively.

As demonstrated by the call to `fmt.Println`, we can now access the
`person1.Name` attribute and get the name that we expect after Unmarshaling.

Unmarshaling JSON into structs and the like presents an interesting case that's
worth exploring: what if the JSON object that we're working with and the struct
that we've created don't match up? By that I mean, what if the attributes are
named differently?

This presents a need to normalize the data, but how do we do that without
changing the struct itself?

## Custom Attribute Names with Struct Tags

Oftentimes, we'll receive JSON data in one format and attempt to serialize it
into a domain object that's *slightly* different. This is commonplace, because
rarely do two different organizations hold data in entirely uniform ways. Some
API's may hold a first name attribute as `firstName` or `first_name`. Someone
may even want to abbreviate it to `fname`!

The point is that there will come a time where we want to normalize different
ways of calling the same data when we work with it in our application. This is
where the concept of __struct tags__ come in.

---

Say we had a JSON string that looked like this:

```go
type Person struct {
  Name string
  Age int
}

jsonStr := `{"fname": "David", "ageInYears": 29}`
```

And then we attempted to unmarshal this JSON string into an instance of the
`Person` struct. We'd get bad results:

```go
import (
	"fmt"
	"encoding/json"
	"strconv"
)

type Person struct {
	Name string
	Age int
}

func main() {
	jsonStr := `{"fname": "David", "ageInYears": 29}`
	jsonStrBytes := []byte(jsonStr)
	var p1 Person
	json.Unmarshal(jsonStrBytes, &p1)

	fmt.Println(fmt.Sprintf("My name is: %s", p1.Name))
	fmt.Println(fmt.Sprintf("My age is: %s", strconv.Itoa(p1.Age)))
}

//=> My name is:
//=> My age is: 0
```

This is because the `Unmarshal` function is looking for the `name` and `age`
attributes in the JSON string it was passed, but can't find them, not knowing
that `fname` and `ageInYears` __are__ in fact the attributes we want (because
we never told it).

This can easily be rectified by defining struct tags next to each attribute,
letting it know where in the JSON object to find the attribute it should place
in the corresponding struct field. Here's what that looks like.

```go
import (
	"fmt"
	"encoding/json"
	"strconv"
)

type Person struct {
	Name string `json:"fname"`
	Age  int    `json:"ageInYears"`
}

func main() {
	jsonStr := `{"fname": "David", "ageInYears":29}`
	jsonStrBytes := []byte(jsonStr)
	var p1 Person
	json.Unmarshal(jsonStrBytes, &p1)

	fmt.Println(fmt.Sprintf("My name is: %s", p1.Name))
	fmt.Println(fmt.Sprintf("My age is: %s", strconv.Itoa(p1.Age)))
}

//=> My name is: David
//=> My age is: 29
```

As you can see, we use backticks followed by `json` and then the name of the
attribute *as it is found in the JSON string*. The `json.Unmarshal` function
knows to analyze the struct tag when it's trying to look for the attribute
that it should place in the appropriate field for the struct.

---

Hopefully this blog post has been helpful in demystifying how the `Marshal` &
`Unmarshal` functions work. Expect another blog post covering the basics
of encoding and decoding!
