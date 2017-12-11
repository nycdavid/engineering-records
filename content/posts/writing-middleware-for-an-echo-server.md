---
title: "Writing middleware for an Echo server"
date: 2017-12-03
tags: ["go", "middleware", "echo"]
draft: false
---

## Requests & Responses

Most web developers are familiar with the concept of the request-response cycle
when it comes web applications:

1. Client makes a request to a specific URL
2. Request makes it's way through each piece of middleware that's configured
on the stack.
3. Request then gets routed to a specific handler according the URL that it made
it's request to.
4. Handler performs what it needs to in it's function body and sends it's
response back.
5. The response gets to the client and the client, in turn, displays what it's
supposed to.

Of course, the above order does depend on the framework you're using and some
frameworks allow for even more granular customization of middleware but, in this
simplified example, the step that we're going to focus on for this blog post is
__step number 2__, the middleware section.

## How does it work?

Middleware can be thought of as functional layers between the client and your
core application code. Think of them as *supplementary* gates that stand between
the request a client makes and the final handler or controller that ultimately
handles the request.

The reason I emphasize the word supplementary is because rarely will a piece of
middleware be the terminating point of the request-response cycle. More often
than not, middleware will instead add something to the request. Maybe a header
or some sort of timestamp or other auxiliary piece of information.

Some common examples of middleware:
- Authentication
- Error handling
- URL parsing (for url-encoded payloads)

The above are just a few of many examples, but, for today, we'll be diving into
writing our own simple URL parsing middleware.

## Essentials of a middleware function

Because middleware is meant to be a standard by which we deal with HTTP
requests, there are certain components that all pieces of Echo middleware must
contain:

* It must be a __function___
* The function must receive `next echo.HandlerFunc` as a first argument
* The function must return a `echo.HandlerFunc` type
* The inner function must receive an instance of `echo.Context`
* The inner function must return a call to `next`, passing the echo context as
  an argument.

I know this sounds like a lot, but you'll see that it's not too bad when looking
at actual code. Here's an example directly from the Echo documentation:

```go
func ServerHeader(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		c.Response().Header().Set(echo.HeaderServer, "Echo/3.0")
		return next(c)
	}
}
```

Inside of the body of the inner function that `ServerHeader` return is where all
of the middleware magic should happen, specifically because it's within that
function body that you have access to the HTTP context. The context is where the
headers, request body and all other request data is contained.

Because we have access to this entity inside of the function, this is exactly
where we'll do some processing and then attach or remove any relevant info to
the request itself.

Once your middleware function is complete, it's time to tell the framework to
start filtering any and all requests through it's internals. We do that by
using the `echo.Use` function.

Finally, the `next` function call is what we need when we've completed our work
with the request and we're ready to pass it to the next component of the
middleware stack with the same HTTP context, effectively allowing the request
to move onto the next bit of processing.

## Calling `echo.Use`

In order to register a middleware function with the Echo stack, we have to
invoke the `echo.Use` function and pass it the middleware function that we
wrote above as an argument.

That would look something like this:

```go
func ServerHeader(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		c.Response().Header().Set(echo.HeaderServer, "Echo/3.0")
		return next(c)
	}
}

func main() {
  echo := echo.New()

  echo.Use(ServerHeader)
}
```

Notice that `ServerHeader` is sent into `Use` as a function rather than invoked.

## Example Middleware: Query Param Parser

Let's try writing a middleware that parses the query params of a URL and stores
that information in the request context so that it's easily fetched by the user.

```go
func ParseUrl(next echo.HandlerFunc) echo.HandlerFunc {
  return func(ctx echo.Context) error {
    
  }
}

func main() {
  echo := echo.New()

  echo.Use(ParseUrl)
}
```
