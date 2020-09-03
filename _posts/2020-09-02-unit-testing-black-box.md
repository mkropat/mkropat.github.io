---
layout: post
title: "Unit Testing: A Black Box?"
date: 2020-09-02
tags: unit-testing
---

The beauty of declarative programming—regexs, SQL, CSS selectors—is that you
don't have to think about the execution model, at least not most of the time.
Yet… somewhere along the journey to mastery you will be forced to understand
the execution model if you want to progress.

If you'll allow the analogy, I think the same pattern occurs with unit testing.
When you start, it's a thing of beauty that you can treat the code under test
as a black box. But as you progress, well…

<!--more-->

With enough unit-testing under your belt, you understand that example-based
testing can never prove every case, while on the other hand, that extensive
test coverage comes with a real cost—have you ever needed to make a simple
change to the behavior of some existing code, only to make the change and have
20 broken tests?  Have you ever run your tests and opened a browser at the same
time, knowing you'd have to wait for the test run to finish?

Justin Searls has an [entire presentation][how-to-stop-hating-your-tests-talk]
on digging yourself out of a terrible test suite. Having a test suite that
hurts more than helps is a real danger.

[![how to stop hating your tests talk](/assets/unit-testing-black-box/how-to-stop-hating-your-tests.png)][how-to-stop-hating-your-tests-talk]

---

It is a fool's game to try to predict how a given piece of code will evolve
long into the future. But you don't have to predict the whole future in order
to make a reasonable guess about specific ways the code __won't__ evolve. That
is where experience comes in.

Once you start factoring those safe bets into your thinking about what tests to
write, you can write fewer tests, as part of test suites that are more
maintainable, all without sacrificing confidence in your test coverage.

## Simple Example

Imagine you want to test some code:

```javascript
if (someCondition && anotherCondition) {
  doSomething();
}
```

What test cases would you expect?

A lot of real world code I've seen would have two test cases 😉

- `someCondition=true`; `anotherCondition=true` → `doSomething()` happens
- `someCondition=false`; `anotherCondition=false` → `doSomething()` does not happen

But you already know what's wrong with that. The following code would pass that
test suite with flying colors:

```javascript
if (someCondition) {
  doSomething();
}
```

Not ideal.

Alright, so what would you expect? The answer is easy, right? 2 dimensions, we
know how to think like computer scientists—make the tests look like a truth
table:

- `someCondition=true`; `anotherCondition=true` → `doSomething()` happens
- `someCondition=true`; `anotherCondition=false` → `doSomething()` does not happen
- `someCondition=false`; `anotherCondition=true` → `doSomething()` does not happen
- `someCondition=false`; `anotherCondition=false` → `doSomething()` does not happen

And if I saw that code during a code review, I wouldn't say a thing. That is a
perfectly good test suite.

But would I write those 4 tests myself? No.

You only need 3 tests:

- `someCondition=true`; `anotherCondition=true` → `doSomething()` happens
- `someCondition=true`; `anotherCondition=false` → `doSomething()` does not happen
- `someCondition=false`; `anotherCondition=true` → `doSomething()` does not happen

Why? What happened to the `false, false` case?

I don't need a `false, false` case because I trust that nobody is going to accidentally update the code to this in the future:

```javascript
if (someCondition XOR anotherCondition) {
  doSomething();
}
```

Heck, logical [XOR](https://en.wikipedia.org/wiki/Exclusive_or) isn't even an operator in any language I use!

Now, this is a simple example where it doesn't really matter either way (4 tests vs 3). But you can probably see how this can happen at larger scales where it does matter.

## tl;dr

Think about your code under test as a black box to start with, but don't be afraid to think about the implementation when it can lead to more maintainable test suites.

[how-to-stop-hating-your-tests-talk]: https://blog.testdouble.com/talks/2015-11-16-how-to-stop-hating-your-tests/
