---
title: "Building a CLI in nodejs"
date: 2018-02-05
tags: ["javascript", "nodejs", "cli", "consul"]
draft: false
meta_description: "In this post, we're going to be going through the process of
writing a command line interface for the Consul service by Hashicorp using nodejs
and the commander.js framework."
---

Today, we're going to be working on something that I feel everyone should at
least have an idea of how to do: __building a CLI__. The best kinds of CLI's
should adhere to the following points:

* Well-tested
* Intuitive to use
* Have easy-to-read documentation

In order to aid us in our CLI-building quest, we'll enlist the help of an
excellent library built by a prolific Javascripter (and really nice guy):
[__Commander.js__](https://github.com/tj/commander.js/) by TJ Holowaychuk.

Commander.js has many high-profile dependents in the wild like: __Babel__,
__React Native__, __Mocha__ and many others.

# Being able to call `cnsl`
Since this blog post will be covering a tool that I actually want and am building
in reality, feel free to follow along with
[the project](https://github.com/nycdavid/cnsl) at your leisure.

Our first milestone in this project should be __being able to call `cnsl`__ at the
command line and having it recognized with __some sort of feedback__. So how do
we do that?

Let's outline the steps:

1. Create a project folder
1. Create an `index.js` file to be run when invoking the CLI.
1. Create a `package.json` naming the above file as the `"bin"` entry.
1. Install the package globally
1. ~~???~~
1. ~~Profit!~~

Assuming, you've already created a project folder, let's create a dead-simple
`index.js` that simply prints out to `stdout` when invoked:

```javascript
console.log('Hello from cnsl!');
```

Now, let's create a simple `package.json`, which can be done by invoking either
`yarn init` or `npm init`.

After generating the `package.json` file, we must add a `bin` key to the first
level of the JSON object that points to our `index.js` file. This `bin` key
provides the path to the JS file that will be executed when we invoke `cnsl`.

```json
{
  "name": "cnsl",
  "version": "1.0.0",
  "description": "nodejs-based Consul CLI tool",
  "main": "index.js",
  "repository": "git@github.com:nycdavid/cnsl.git",
  "author": "David Ko <david.ko@velvetreactor.com>",
  "license": "MIT",
  "scripts": {},

  "bin": "./index.js",

  "dependencies": {
    "commander": "^2.13.0"
  }
}
```

Before we continue, we have to make sure that we add what's known as a __shebang__
to the top of the `index.js` file. That looks like this: `#!/usr/bin/env node`.

Because we're asking the system to execute our script as a shell command, we
need to tell it how to interpret all of the lines to follow, and in this case
we want it to execute the file as a nodejs script. Now our `index.js` file
should look like this:

```javascript
#!/usr/bin/env node

console.log('Hello from cnsl!');
```

Finally, we install the package globally with `npm install -g` run from the project
folder and we should be able to invoke `cnsl` and get our output.

![Demonstration of invoking cnsl](https://i.imgur.com/Y0PPU0i.gif)

# Having `cnsl` recognize a command
A CLI that only outputs one thing irrespective of the inputs given to it by a user
isn't super helpful. Ideally, we'd like for it to __output different things__
depending on the __type of command provided__.

Let's make our 2nd milestone: __Have `cnsl` echo what we say to it__.

How do we want to invoke it? How about we make it an option flag like:
`cnsl --say "Repeat after me"`

Commander.js makes this incredibly simple: first let's `require('commander')` in
our executable `index.js` file and ensure that Commander parses the arguments
given to it.

```javascript
// index.js

const cnsl = require('commander');

cnsl.parse(process.argv);
```

At this point, you should be able to run `cnsl --help` and get a nice, little
menu just like all of the CLI tools that you're used to:

![Invoking cnsl --help](https://i.imgur.com/mqaLx9r.gif)

Commander.js does all of this automatically!

Now, let's use Commander.js' `option` function to define a flag that will be
available when invoking `cnsl`:

```javascript
// index.js

const cnsl = require('commander');

cnsl.option('-s, --say [phrase]', 'Make cnsl speak');
cnsl.parse(process.argv);
```

The last part of this milestone is having `cnsl` detect the input string and
`console.log` it back out. To do that, we have to:

* detect whether it was supplied or not.
* If it was, interpolate it into a string and `console.log` it.

Detecting whether a flag or option was supplied is done by invoking the name
of the option on the `cnsl` object in the execution script. This exists as a
boolean and is convenient to put into a `if` clause like so:

```javascript
// index.js
const cnsl = require('commander');

cnsl.option('-s, --say [phrase]', 'Make cnsl speak');
cnsl.parse(process.argv);

if (cnsl.say) {
}
```

The interpolation step is a bit more interesting. Commander uses C-style `printf`
format specifiers for string interpolation, much like the Go language does. If
you've never seen it before, the basic idea is that you __place a `%s`__ where you
want the value interpolated.

Let's add a `console.log` to our code in this manner:

```javascript
// index.js

if (cnsl.say) {
  console.log('%s', cnsl.say);
}
```

And the effect of our code:

![Repeat after me!](https://i.imgur.com/989cYix.gif)

# Something we can use
A CLI that echos what we give it isn't the most interesting nor useful tool, so
let's have it do something a bit more difficult.

Assuming we have a cluster of Consul servers and an agent which we have set up and
listening at `localhost:8500`, let's have `cnsl` query that agent for its members.

First, we want to __add an option__ for Consul Agent-related requests, `-A, --agent`
and have it make the correct HTTP request according to the option argument it was
passed.

Let's see what the code for that looks like:

```javascript
cnsl
  .option('-A, --agent <cmd>', 'Call the Consul Agent API');
```

Now, let's give it a callback function that gets executed when the option is
provided to `cnsl`:

```javascript
cnsl
  .option('-A, --agent <cmd>', 'Call the Consul Agent API', async cmd => {
  });
```

Notice that we're using the [async/await pattern](/posts/async-await) here because
we'll making an asynchronous HTTP request in this function.

Let's also create a small wrapper for the return object, as there will a lot of
extraneous information from the Consul Agent API, that we don't need to concern
ourselves with for this example:

```javascript
function Member(json) {
  this.name = json.Name;
}
```

Finally, we'll add the body of the function to handle the command:

```javascript
cnsl
  .option('-A, --agent <cmd>', 'Call the Consul Agent API', async cmd => {
    let url = `http://localhost:8500/v1/agent/${cmd}`;
    let res = await request.get(url);
    let apiMembers = res.data;
    let members = apiMembers.map(member => new Member(member));
    console.log(members);
  });
```

Notice that the __first argument of the callback function__ is the actual command
that we supplied to the `--agent` option.

Let's see it in action!

![Making a request to the Consul Agent API via cnsl](https://i.imgur.com/hB6Ea2M.gif)

---

I hope you've enjoyed this brief tour of Commander.js and writing CLI tools in
node! Give the exercise(s) below a shot and let me know how it goes!

# Exercise(s)

1. Write tests for the above command.
1. Handle an error when a command provided is unknown.
