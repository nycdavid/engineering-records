---
title: "3 Methods of Fetching Data Changes: A WebSockets Primer"
date: 2018-01-15
tags: ["javascript", "websockets"]
draft: false
meta_description: "In this post, we examine several different methods that are used to fetch data from the server along with their pros and cons. We close with examining a simple implementation of a client-server WebSocket architecture that pushes message to a browser which then renders them."
---

# WebSockets: A high-level overview
## Method #1: One response for one request
The traditional web application, as we know it, uses the request-response cycle
to get any updates from the server that it may need to display. That is:

* A browser makes a request to the server.
* The server responds with what, at the time of the request, is the most up-to-date
data that it has.
* The browser displays what it was given.

After the response has left the server, any number of updates can happen, especially
if the application is in use by multiple people.

1. __8:00 AM__: Browser makes a request for the latest number of Widgets sold.
2. __8:01 AM__: Server reads the database and responds with 5 (the number sold as of 8:01 AM)
3. __8:02 AM__: Jane sells 10 more widgets (bumping the number sold up to 15)
4. __8:03 AM__: David's browser, currently awaiting a response, receives the one sent at 8:01 and displays 5 widgets sold.

David won't see the latest changes until he refreshes his browser, thereby making
an additional trip to the server to fetch data.

![An example of the traditional request-response cycle](https://i.imgur.com/HZyF45f.gif)

Granted most request-response cycles are not nearly as segmented nor as slow as
the above, the example illustrates the difficulties in keeping static displays
of data up-to-date, especially during concurrent (>1 user) use.

[Example code here](https://github.com/nycdavid/redvelvet-examples/tree/master/websockets-in-the-browser#static-example)

## Method #2: Asking again and again (Polling)
An improvement on the above, is the method of __polling__ for changes.

In this pattern, the initial data is loaded the same way as it is above, but a
recurring task is set up in the background so that every so often a request is
made to the server to grab the data (which could have been updated) and bring it
to the user.

This is most often done "invisibly", so it appears to the user that the data is
changing before their eyes without them ever having to refresh.

From a UX standpoint, this is certainly a step up: a user doesn't have to do anything
but sooner or later they're always looking at the latest (or semi-latest) data.

![An example of AJAX-based polling](https://i.imgur.com/JShrOD3.gif)

As you can see above, when we use polling, we open a new HTTP connection every
second or few seconds in order to grab the freshest data from the server, which
we then render to the user.

Unfortunately, this approach __would not scale__. Let's say that the polling
request is made every second, so 60 times a minute. That's 3,600 times per hour
__per client__. And that's only assuming each client has one tab/window open of
the app.

It's easy to see how the above approach could create quite a bit of HTTP/Server
overhead, if implemented. Compound this with a slow operation like a database
read per request, and we're simply asking for trouble down the road.

There's also a bit of what I like to call, for lack of a better term,
"inefficiency icky-ness": we're asking the server over and over again if there
have been any changes, even if none have been made. We're downstream of
the change, so we just have to keep asking, never knowing when it'll happen.

[Example Code Here](https://github.com/nycdavid/redvelvet-examples/tree/master/websockets-in-the-browser#polling-example)

If we were allowed to just go about our business and simply __be notified__ when
a change has been made, we could all rest easy!

## Method #3: Just let me know when it happens (WebSockets)
Finally, the main course of this article: listening to a WebSocket for changes
from the server.

The flow of this technique happens in, roughly, the following steps:

1. A server-side WebSocket starts listening on the port of your choice (we'll use
`8080` for our example.)
1. From the client-side, we use the the browsers native WebSocket object to connect
to `localhost:8080` and listen for changes.
1. From the server-side, we communicate messages on the Socket connection to the client.

### 1. Setting up the WebSocket Server
For this example, we're going to run a WebSocket server from the node REPL so
that we can send messages in real-time.

You can either type the commands on your own, or clone
[this project](https://github.com/nycdavid/redvelvet-examples) and follow the
[WebSockets Example README info](https://github.com/nycdavid/redvelvet-examples/tree/master/websockets-in-the-browser#websockets-examples)
in the `websockets-in-the-browser` folder.

If you chose not to clone the project and follow the README, make sure to
have the `ws` npm package installed locally.

```javascript
const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8080 }); // 1.

let connections = []; // 2.
wss.on('connection', ws => { //
  connections.push(ws);      // 3.
});                          //
```

Lets breakdown what's happening above:

1. We start a new WebSocket server on port `8080` (the full URL of the server is
  `ws://localhost:8080`)
1. We declare a `connections` array that will eventually hold our client connections.
1. Every time a client connects to the WebSocket Server, we add that client
connection to the `connections array`.

At this point, the server is running, so let's turn out attention to the clientside.

### 2. Client-side: listening for data
On the client-side, we'll be listening for messages from the server and then
altering HTML on the page when messages come in.

The way we listen for messages is by assigning a function to the `onmessage`
attribute of the WebSocket object.

This function gets triggered every time a message is sent from the server and
the first argument, conveniently, is the `MessageEvent` that contains the data
sent.

Consider the following example code:

```html
<h1>Word of the Day: <span class="wotd"></span></h1>

<script type="text/javascript">
  let wotd = document.querySelector('.wotd'); <!-- 1. -->
  let ws = new WebSocket('ws://localhost:8080'); <!-- 2. -->
  ws.onmessage = function(evt) { <!-- 3. -->
    wotd.textContent = evt.data;
  }
</script>
```

Again, let's break down the above, step by step:

1. Find and store the HTML tag that contains the bit of text we want to change.
1. Open a WebSocket with the address obtained from the previous, server-side step.
1. Assign a function to the `onmessage` attribute of the WebSocket object and have
it replace the text inside of the HTML tag with the data received from the server.

Now that we've set up the client-side to handle incoming messages, we're finally
ready to send some over!

### 3. Sending messages
Now, let's flip back over to the node console, where we have the `connections`
array. This array should now be holding the connection that was made from the
code above.

Using this client connection, we're able to use the `send` method and communicate
whatever text string we want. The `onmessage` handler will trigger once it's
sent, and render the data inside the HTML tag.

```javascript
let firstClient = connections[0];
firstClient.send('A message');
```

Let's see it in action:

![Demonstration of real-time changes with WebSockets](https://i.imgur.com/UcWyU5f.gif)

Although we're manually sending messages in this case, the `send` method could
just as easily be hooked into an after-save-style callback that sends an updated
data record to a client to publish real-time changes.

---

WebSockets offer a nice, lightweight interface for pushing changes from server
to client and allows you to mitigate some of the issues posed by static data
pages and time/interval-based polling.

I'd love to hear the use-cases that you've found for integrating WebSockets in
your projects! Make sure to let me know via email or the comments section below
how your experimentation with WebSockets go!
