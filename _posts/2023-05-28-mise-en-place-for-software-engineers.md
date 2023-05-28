---
layout: post
title: "Mise en Place for Software Engineers"
date: 2023-05-28
tags: team agile
---

<p style="text-align: center"><img alt="working on a laptop like a cooking show" src="/assets/mise-en-place-for-software-engineers/cooking-show-laptop.webp" style="width: 40%" /></p>

You know how in cooking shows they have all the bowls full of ingredients in front of them, ready to go so that when they start cooking there is no risk of something not being ready at a critical moment? There is a cooking term for that, *mise en place*, which roughly translates to "putting in place".<sup><a href="#note-1">1</a></sup> It's not just for TV either. *Mise en place* is taught to and practiced by professional chefs, because upfront preparation<sup><a href="#note-2">2</a></sup> prevents costly mistakes later.

BTW it is pronounced like MEEZ ahn PLAHSS (ah = the "a" in father).

<!--more-->

Having pair programmed with many software engineers over the years, I can say there is an underappreciated lesson there. Not because coding is time-sensitive in the same way. Unlike cooking, coding typically doesn't involve critical moments where a lot of moving pieces have to be juggled within the span of minutes.<sup><a href="#note-3">3</a></sup> But because coding is also **interrupt-sensitive**. Except instead of the finite resource being time, the finite resource is the ability to hold context in your brain.

Systems that are actively worked on inevitably grow in complexity until working on them is at the limits of what the engineers who maintain it can hold in their head. Engineers who run into frequent interruptions are going to fall behind their peers who learn how to minimize them.

### What to prepare?

What *mise en place* looks like for you is highly dependent on the environment you are working in. Maybe you are lucky enough to work on a project where can spin up the development environment in seconds. If that is the case, you are kind of always prepared, so you don't have to make a point to do it ahead of time.

What follows are some examples I've seen that interrupt pairing sessions. It is by no means comprehensive, but hopefully enough to give a sense of what to look for.

#### Log in to relevant systems

Start the day by logging into any systems you'll be using throughout the day. Probably your company's SSO. Perhaps other systems. For me lately, I make sure I'm logged into ChatGPT.

A system of note is the ticketing system (Jira, etc.). When used effectively, it is both invaluable for reference information about what you are working on, and something that you want to be updating several times a day. Not only do you want to be logged in, you probably want it open and pinned so you can switch in and out of it seamlessly.

As an aside, sometimes you need multiple, mutually-exclusive logins for the same site. Perhaps you need to regularly access multiple AWS accounts. Consider making multiple browser profiles, each one logged into a separate account. That way switching between accounts is as simple as switching between windows--no need to stop what you're doing and re-log-in.

#### Close out old tabs and windows

It is hard not to be a tabaholic when your job regularly requires research and having lots of reference material open. Unless you are picking up where you left off, leaving old tabs open creates a mess that makes it easy to get lost in later when you start working on new things. There are many tools that can make managing tabs easier. Personally I'm a big fan of [OneTab](https://www.one-tab.com/), I use it whenever I start a pairing session so we can share a clean work space.

Besides tabs, maybe you have a bunch of applications open that are no longer needed. Clean those up too.

#### Have your development environment running

Whether your development environment runs locally or in the cloud, it goes without saying that you want to have it set up to run. More than that, I recommend actually building and/or running the project you will be working on.<sup><a href="#note-4">4</a></sup> It usually only takes a second to kick off, and can save minutes of flow interruption down the road. A pet peeve of mine is showing up to a scheduled pairing session, discussing context, looking at the relevant code, deciding on a course of action, making a change, and then… wait while the last 10 minutes of built up momentum grinds to a halt while we do a cold start of the application or tests.<sup><a href="#note-5">5</a></sup>

Equally important to running the application is making sure the tests are ready to run, since coding often begins with iterating on the tests. Thankfully this is usually easy, sometimes as simple as making sure all dependencies are installed.

#### Have tools ready

On some projects you need little more than the application and tests to be able to develop and debug the application. Other times you need more help:

- Database client
- Profiler
- Runtime debugger
- Web/network debug proxy

Figure out which tools come in most handy and have them ready.

#### Take care of computer hygiene

In contrast to the other items, this one is often best done at the end of the day.

Persistent software update pop-ups are distracting. Forced update reboots are far worse. When you know you have a software update that needs to be done, set a reminder for yourself to take care of it at the end of the day (or lunch break or whenever).

### Do I have to be prepared for everything all the time?

Rarely is software engineering static. I may work on one part of a project for one month, then just as easily work on a completely different area of the project or different project altogether the next month.

Don't rotely prepare the same things every morning, long past when they're useful. If you haven't used something in weeks, maybe you don't need it.

For the things that are useful, however, a little discipline upfront, to put things in place, goes a long way towards making you a successful software engineer.

## Notes

1. <a name="note-1"></a> [According to Wikipedia](https://en.wikipedia.org/wiki/Mise_en_place) anyway, it's not like I know French.
1. <a name="note-2"></a> Just so I don't leave you with the wrong impression, *mise en place* is more than just ingredient prep, it's a whole philosophy. Pre-heat the oven. Gather all the tools you need. Basically think ahead so you don't find yourself in a bind later.
1. <a name="note-3"></a> Time-critical moments can occur, like when production is on fire, but hopefully that is rare.
1. <a name="note-4"></a> This may not always make sense, like if you have to cold restart everything anyway whenever you switch branches, then it wouldn't make sense to pre-run the application at the start of the day. As usual, do what makes sense in your circumstances.
1. <a name="note-5"></a> Consider starting every pairing session with, "before we begin, let's kick off the tests and run the application," as a collective reminder. I always forget to bring this up though.
