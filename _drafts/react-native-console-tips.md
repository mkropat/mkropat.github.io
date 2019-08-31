---
layout: post
title: "How to require() from the React Native console"
date: 2019-9-12
tags: react-native debugging
---

ES6 modules are a great innovation in JavaScript. We finally have a moduling standard that works for whatever platform you are targeting—the browser, Node.js, or, heck, mobile applications (with React Native).

However, as easy as ES6 modules make it to import your code from any other part of your code, they seem to make it equally hard to access your code at all from the debug console. Thankfully, it is usually not impossible to get access. You just need to know some hidden features of the bundler.

<!--more-->
