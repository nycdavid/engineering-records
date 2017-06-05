---
layout:     post
published:  true
title:      "Introducing: dynamornr"
subtitle:   "A DynamoDB taskrunner"
date:       2017-06-05 12:00:00
author:     "David Ko"
header-img: "img/post-bg-01.jpg"
categories: golang cli taskrunner dynamodb
---

I've recently started an initiative to improve my Golang chops by forcing myself
to write Go daily. The datastore that I've decided to use (Amazon's DynamoDB) is
still a bit rough around the edges and is, IMO, not as user-friendly as one might
like.

Of course, me coming from a Ruby/Rails background, am used to practically a rake
task for everything that a dev could possibly need, and it's in that vein that
this project was started. Sort of a scratch-your-own itch type of thing.

I wanted a simple, clean, CLI-based tool that you could run database-creation and
listing tasks with and that would connect to any DynamoDB database that you gave
it whilst retaining Rake-like ease-of-use.

Maybe I'm just too used to Rails migrations or maybe it's just a good system
(I feel that I'm not experienced enough in systems design to give a definitive
answer here) but I wanted to create a similar migration tool for Golang developers
to keep their databases updated and in-sync as they build their web applications.
A migrations system like the one created for ActiveRecord seemed like a good place
to start.

[dynamornr repo](https://github.com/nycdavid/dynamornr)

Hopefully it helps someone out somewhere. I'll definitely keep adding to it as
features that I need pop up.
