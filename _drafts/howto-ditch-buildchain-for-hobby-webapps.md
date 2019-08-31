---
layout: post
title: "How to Ditch the Toolchain On Your Hobby Webapp"
date: 2022-09-03
tags: javascript react
---

<p style="margin-top: 4ex">I needed a way to make web development fun again.</p>

Don't get me wrong, writing a modern, but bog-standard React app can be fun. It can be even more fun to figure out how to write an app using one of the [excitingly](https://svelte.dev/) [different](https://www.phoenixframework.org/) ideas out there.

I feel lucky because I've seen this whole web things from the beginning. When I made my first website it was on Geocities. When I learned to code it started with CGI scripts, quickly to PHP, jQuery on the frontend, the rise of MVC frameworks, early JS stepping-stones like Backbone and Angular.js, and ultimately to the behemoth that is React.

Things are so slickly professional now. This is highly *convenient* as someone paid to build large webapps. As a hobbyist too, though? I spend as much time picking a framework, as I do fiddling with the build toolchain, as I do actually hacking on my side-project idea. Then I take a 6-month break and rack up the Dependabot PRs on my statically deployed website. When I am ready to hack again I get to decide if I want to update to the next major framework version and figure out why Webpack isn't bundling any more.

<!--more-->

Just as a fish doesn't know it is in water, it was almost impossible for me to see what was draining the fun out. Every JavaScript framework out there competing for your attention has the ambition to be able to used for serious work. <sup><a href="#note1">1</a></sup> And everyone "knows" you can't ship serious work by uploading your `src` directory somewhere—you need a build toolchain (more on this point later). So every framework README, tutorial, and guide wants you to use a toolchain.

Only by pulling a dim memory from another epoch did I recall that things could be any different. In the Geocities-era no tutorial started by having you set up a toolchain. The only delay between making a change and seeing it running was pressing <kbd>F5</kbd>. Debugging was simple—no source maps to set up, no complicated stack traces. If you wanted to learn from someone else's work, you didn't have to hope for it to be published as an open source project and then track it down, you just pressed *View source*.

The toolchain had to go. But what was I going to replace it with? No modern framework is designed to run without one.

## Wait?? Aren't you just describing VanillaJS?

In a loose sense, yes. But I need to draw a distinction.

Every example of VanillaJS code I've ever seen is built like an app from the jQuery era—other than not actually using jQuery of course. The [various](http://vanilla-js.com/) [VanillaJS](http://vanillajs.net/) [websites](https://vanilla.js.org/) were literally set up as a reaction to jQuery—disputing not the architecture but reacting to the unnecessary use of an API wrapper library. Even looking at a [modern example](https://github.com/tastejs/todomvc/tree/gh-pages/examples/vanilla-es6) it is consistent with with the period—an example of an unusually clean architecture from the era—but vintage all the same.

I am not here to discourage anyone from writing in that style. It worked then, and if it works for you now, go for it.

However, personally, __my brain has been re-wired from writing React apps__ and doing functional programming for so long. Specifically I design webapps in terms of:

1. UI is a function of state
2. Unidirectional data flow

For this to work I was going to need to discover—stumble upon really—some pattern that was kinda like React, except would it be possible to do it without re-inventing all the complicated framework logic, and virtual DOM diffing, and without leaning heavily into brand new syntax (JSX)?

## Introducing tags.js • TodoMVC

I am happy to report back that 

### UI is a Function of State

### Unidirectional Data Flow

### Notes

1. <a name="note1"></a> Sure, the framework may bill itself as fun. But always the hope is to be able to get paid to work in that fun framework as part of their day job.
