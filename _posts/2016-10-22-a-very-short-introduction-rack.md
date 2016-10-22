---
layout:     post
published: true
title:      "A Very Short Introduction: Rack"
subtitle:   "What it's for & how it's used."
date:       2016-10-22 12:00:00
author:     "David Ko"
header-img: "img/post-bg-01.jpg"
---

If you've worked in Ruby for any length of time, I'm sure you've heard of the Rack gem and maybe the term "rack middleware". In this article, we're going to go over a very short overview of what Rack is and what it does.

To start off, Rack is all about talking to HTTP requests on the level in which they're received, that is, on the webserver level. Thus, you could say that it's the backbone with which many a Ruby web application is built. Even Rails has a Rack middleware stack of about 10-15 pieces that serve several different purposes related to the processing of incoming requests.

So because nearly all Ruby web frameworks utilize Rack to power their HTTP interface, it's important, in my opinion, to learn about what it is and how it works, if not only for the reason that learning the different types of magic that happens under the hood in your favorite frameworks is __key__ to (later on) customizing those frameworks to your specific use case.

Whether you want to performance tune, or break a large application into several different microservices, learning about something that works as closely with the request/response cycle as Rack can influence your design decisions in ways that can pay dividends over the long term of a project.

But before we dive into details and code, let's start from the beginning and see who created it and why.

# A Brief History of Rack
  Let's first dive into a very short summary of the history of the Rack gem, built by the very talented Christian Neukirchen (also the author of the Bacon test framework). Christian first released `v0.1` of Rack in March 2007, as an effort to rally the Ruby web application developer community behind a standardized interface for interacting with HTTP requests and responses.

  ![Christian Neukirchen](https://usesthis.com/images/portraits/christian.neukirchen.jpg)
  <small>*Christian Neukirchen*</small>

  The rationale was that if all clients are sending requests and expecting responses that conform to a specific protocol (HTTP), then the applications receiving these requests should *also* be able to work with those requests in a standardized way, minimizing the amount of disparity across code-bases. In having a unified way in which we interact with HTTP, logic and app code that conforms to those standards can now talk to each other as well, creating a simple but powerful modular system that provides nearly endless amounts of flexibility.

  The popularity of Rack and it's sheer number of contributors (__116,976,016__ downloads, __2,201__ commits, __296__ contributors at the time of this writing) is a testament to it's sensibility and ease-of-use. Even Ruby framework giants like Rails & Sinatra both incorporate the modular Rack pattern for requests they receive, allowing developers to leverage it if they ever feel the need to manipulate the request at that low a level.

# ...*so `call` me maybe*
  ![Call Me Maybe]({{ site.url }}/img/intro-to-rack/carlyrae.jpg)
  <small>*Let's let this set the tone for the rest of this post...*</small>

  How do we make an application (or piece of logic) that conforms to the standard set forth by the Rack spec? If you read the [SPEC](https://github.com/rack/rack/blob/master/SPEC) file in the current `rack/rack` repository, you'll see that it clearly outlines the (deceptively simple) criteria that a Ruby object must fulfill in order to be compliant with Rack. It states:

  > A Rack application is a Ruby object (not a class) that responds to `call`.

  That's practically it! There are some smaller, ancillary details (like what `call` must execute/return, for instance) that I'll explain further down but if you take nothing else from this article, just remember this: every OBJECT (everything is an object in Ruby) that can respond to the message `call` without throwing an exception IS a Rack-compliant application.

  The distinction made in the spec is intentional (and important) because one's instinct may be to believe that Rack will only accept classes and modules with `call` defined on them, but, as you'll see in the next example, this isn't necessarily the case.

```ruby
  # config.ru

  class RackAppClass
    def call(env)
      [200, {}, []]
    end
  end

  module RackAppModule
    def self.call(env)
      [200, {}, []]
    end
  end

  rack_app_proc = Proc.new do |env|
    [200, {}, []]
  end

  rack_app_lambda = lambda do |env|
    [200, {}, []]
  end
```
  I mentioned above that the emphasis the Rack documentation places on Rack app's being *object's* was intentional, and hopefully the last two examples in the above code snippet have illustrated why. The `RackAppClass` and `RackAppModule` have the `call` method defined on it and are explicitly Rack-compliant.

  However, you might be asking yourself, why are `proc`s and `lambda`s included in this list? If you've ever had a chance to use either of these two Ruby constructs, you'll probably know that both are a type of stored function that can be placed in a variable and then invoked later via the method name...you guessed it: `call`! Thus, by virtue of being a proc or a lambda, it's already Rack-compliant!

  Because of this loosely defined interface, we can sew together multiple objects as modular layers of logic that all conform to the Rack specification at their seams, allowing Rack to know how to put them together.

# Examining the Rack environment
  You may have noticed that I pass an `env` parameter into each of my 4 examples in the above snippet of code. What is this parameter?

  This `env` argument is effectively a Ruby hash representation of the request that our Rack application is receiving, and so, has several pieces of information about the request that can be used to manipulate it in creative ways:
  * The HTTP version
  * The host that the request was made to
  * The request verb (i.e. GET, POST, etc.)
  * The request headers
  * The query string

  The very nice thing about our Rack environment and how it interacts with middleware is that we use can it to parse portions of the request, act on them, return status codes, store data in the request itself, etc. The possibilities can be as creative as you can be and people have already contributed tons of different kinds of middleware to the Ruby & Rack ecosystem.

# An ultra-minimalist Rack "app"
  Simply responding to `call` and doing nothing afterward would make for a pretty useless and boring app so let's have our `call` method doing something useful now!

  Because a webserver usually sends a minimum of 3 entities of information back to a Browser or other Client, Rack requires that every piece of logic layered onto the big Rack cake have a `call` that be able to do the following:

1. Accept a single parameter (usually called `env`) that represents the Rack environment (we mention this above)
1. Either:
  * Call the next piece of Rack logic in the stack (this will be covered in my future article about middleware) OR
  * Return an array of 3 elements:
    1. An integer value greater than 100 (for an HTTP status code)
    2. An hash that usually corresponds to the Response headers
    3. An array that contains the response body (every element in this array must be a string)

  Thus, if we wanted a Rack app that always returned the current time, we could do a dead-simple one like this:

```ruby
  class TimeApp
    def call(env)
      [200, { "Content-Type" => "application/json" }, [DateTime.now.to_s]]
    end
  end

  run TimeApp.new
```

  How about we try an app that's a tiny bit more complicated and that actually accepts a little input from a client?

  The ultra-minimalist Rack app that we're going to build, is going to be a markup-generation app that receives a JSON representation of an array in a header and converts that array into an HTML `<ul></ul>` element with the inner array elements as list items.

  Also, let's have our templating Rack app, *Listify*, take an additional request header that will correspond to an `<h1>` tag in our template.

```ruby
  # our config.ru

  class Listify
    def call(env)
      @title = env["HTTP_X_LISTIFY_TITLE"]
      @items = JSON.parse(env["HTTP_X_LISTIFY_ITEMS"])
      [200, { "Content-Type" => "text/html" }, [compile_html]]
    end

    private

    def compile_html
      title_string = "<h1>#{@title}</h1>"
      li_string = @items.map { |item| "<li>#{item}</li>" }.join
      "#{title_string}<ul>#{li_string}</ul>"
    end
  end

  run Listify.new
```

  In the above snippet of code there are several different things happening:

  1. In our `call` method, we are parsing the HTTP headers for two different values:
  - one corresponding to the title that we want to place in a heading tag (`HTTP_X_LISTIFY_TITLE`) __and__
  - another that contains a JSON string array that corresponds to our list items (`HTTP_X_LISTIFY_ITEMS`).

  1. In our return array, we're returning a successful `200` status code, a `Content-Type` of `text/html` and an array which contains the server's response body. In this case, we're making a call to a private method, `compile_html`, which will return the HTML string that we'll send to the client.

  1. `compile_html` interpolates the title into an `<h1>` tag and maps the item array into a list item markup string.

  If we send a request with the appropriate headers in Postman, we'll see that we receive the template string that we expect as HTML markup:
  ![Postman Screenshot]({{ site.url }}/img/intro-to-rack/postman.png)

  And that's it! We have our dead-simple Rack templating engine that receives values from the client and interpolates them into an HTML string that gets served up!

# What good shall I do today?
  Hopefully this insight into Rack has been a positive learning experience for all those who are reading this article, if not solely for the possibility of it sparking ideas in your head for various middleware and other extremely poignant yet powerful pieces of "close to the metal" logic.

  Go forth and build easy-to-maintain yet valuable software!
