---
title: "Simplifying Go templates"
date: 2017-11-04
tags: ["go", "templates"]
draft: false
---

At long last, I'm back to blogging after reading an
[informative and inspiring post](https://blog.codinghorror.com/how-to-achieve-ultimate-blog-success-in-one-easy-step/)
by Jeff Atwood.

Today, I wanted to write about Go's `text/template` package because I never truly felt
I had a good grasp on it and I hope that, by doing the research and experimentation
necessary for this blog post, I'll be able to learn enough about it to solidify
my understanding.

## Basics

Generally, one can think of a template (any template) as a Mad Lib. We have some
collection of pre-defined text with blank spaces scattered throughout it where we
can insert whatever words or phrases we want.

Thus, whenever we want to generate text from a template, we need two things:

* A __template__ that calls for different points of data
* A __data object__ that holds the data that the template looks for (at accessible and identifiable keys)

Let's start with writing out some kind of template. We'll start with a very simple one that,
when completed, will output the sentence "My name is [NAME] and I'm [AGE] years old."

---

1. First, we start by writing out the string that is to be our template and replacing
the positions of it with handlebars-style interpolation blocks.

{{<highlight go "linenos=true">}}
templateString := "My name is {{.Name}} and I'm {{.Age}} years old."
{{</highlight>}}

Let's stop to notice that there is a period (.) in front of the attribute name.
This is necessary for Go's template parsing and must always be there.


1. Let's now create a data object to join this template and have it provide the data
that it expects. We'll use Go's almighty struct for this:

{{<highlight go "linenos=true">}}
type Person struct {
  Age  int
  Name string
}
{{</highlight>}}


Also worth noticing: the case in the attributes of the above struct *match the ones
called for in `templateString`.*

1. Next, we'll create a new, named template and pass it the string we created above
to prepare it to receive data. We'll also use two functions from the `template`
package: `New` & `Parse`:

{{<highlight go "linenos=true">}}
// template#New : func New(name string) *Template
// Accepts a string as the name and returns an instance of *Template

// template#Parse : func (t *Template) Parse(text string) (*Template, error)
// Method on *Template and accepts the template string to be parsed
// Returns *Template, or an error

templateString := "My name is {{.Name}} and I'm {{.Age}} years old."
tmpl, err := template.New("davidSentence").Parse(templateString)
{{</highlight>}}

1. Finally, we call `Execute` on the template which compiles a brand new text string
according to the data provided to it and writes it to an `io.Writer` of your choice.

{{<highlight go "linenos=true">}}
// template.Execute :  func (t *Template) Execute(wr io.Writer, data
// interface{}) error
// Invoked on an already existing instance of Template, Execute writes a
// fully compiled text string to an `io.Writer` like os.Stdout

type Person struct {
  Age  int
  Name string
}

templateString := "My name is {{.Name}} and I'm {{.Age}} years old."
tmpl, err := template.New("davidSentence").Parse(templateString)
if err != nil {
  panic(err)
}
david := Person{Age: 29, Name: "David"}

tmpl.Execute(os.Stdout, david)

// #=> My name is David and I'm 29 years old.
{{</highlight>}}

## Handling more complex types (like enumerables)
Interpolating simple data types are handy, but the true power of templates comes
in their expressiveness and the ability to generate large blocks of text with simple
directives, like iterating through a block and creating text for each iteration.

This is where the `range` directive in Go's templating package comes in.

---

Suppose we have a slice of strings called `fruit`:

{{<highlight go "linenos=true">}}
fruit := []string{"Apple", "Banana", "Strawberry"}
{{</highlight>}}

When we create a template to display the above data, we first create a template string
with a `range` block:

{{<highlight go "linenos=true">}}
tmplStr := `
  List of my favorite fruit:
  {{range .}}
  {{end}}
`
{{</highlight>}}

the `.` indicates that the data to enumerate on is available at the root (and
does not have to be found with a specific key)

Within the `range` block, we have access to the individual elements of the enumerable,
thus we're able to access (and display) them by:

{{<highlight go "linenos=true">}}
tmplStr := `
  List of my favorite fruit:
  {{range .}}
  - {{.}}
  {{end}}
`
{{</highlight>}}

Again, the `.` here means that we're accessing the data stored at the root of the
element. If, for example, the element was a map or struct instead of an array,
we'd access the data via `{{.[ATTRIBUTE]}}` instead.

Now that we've crafted our template string, we're able to create a template
and execute it with the appropriate data:

{{<highlight go "linenos=true">}}
fruit := []string{"Apple", "Banana", "Strawberry"}
tmplStr := `
  List of my favorite fruit:
  {{range .}}
  - {{.}}
  {{end}}
`

tmpl := template.New("favoriteFruit").Parse(tmplStr)
tmpl.Execute(os.Stdout, fruit)

//  Favorite fruit:
//	- Apple
//	- Banana
//	- Strawberry
{{</highlight>}}

## Refactoring your templates into files
Declaring a template inline in your code is perfectly fine and *does* work,
however, as software engineers, we often encourage each other to promote re-use.
What better way to allow re-use of our template than to refactor it into a file
that we can read in?

---

Let's create a file called `fruit.txt`:

{{<highlight go "linenos=true">}}
// fruit.txt

List of my favorite fruit:
{{range .}}
- {{.}}
{{end}}
{{</highlight>}}


Now, instead of using the `Parse` method for a template string, we can use the
`ParseFiles` method to look for files that contain the templates we want to
register.

{{<highlight go "linenos=true">}}
tmpl, err := template.New("fruit.txt").ParseFiles("fruit.txt")
{{</highlight>}}

The only thing to ensure here is that the `name` parameter matches the name of
file, *including the extension*. Otherwise, the template parsing may not be
able to match the name to the file name, breaking your templating engine.

That's it! Executing the template is accomplished the same way as it is above
and you can have nice, clean templates separated into however many files you'd
like!

Hopefully this was helpful! Expect plenty of more blog posts and Go and
templates in the future!
