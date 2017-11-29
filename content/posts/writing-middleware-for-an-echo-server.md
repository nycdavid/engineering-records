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
