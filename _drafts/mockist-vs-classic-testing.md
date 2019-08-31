---
layout: post
title: "Mockist vs Classical Testing"
date: 2018-11-21
tags: unit testing
---

I've been thinking a lot about mockist vs classical testing lately. It seems like I do this at some point every year. Chances are it has something to do with me being a developer with classicist tendencies working in a mockist dev shop.

<!--more-->

If you are not familiar with the "mockist" and "classical" terms, they were popularized in a [Martin Fowler essay on the subject confusingly titled "Mocks Aren't Stubs"][mocks-arent-stubs]. Roughly defined:

- __Mockist__ – prefers to use test doubles to implement assertions, frequently testing abstractions in complete isolation
- __Classical__ – prefers to assert on the state/value of a subject, frequently testing several (small) abstractions together

"Abstraction" here could mean any number of things—perhaps a function, a class, or a source file. I do a lot of React testing nowadays, so the abstractions I deal with are components, higher-order components, and modules.

While useful for grouping and talking about different ways people write tests, I think the terms are overloaded. Just from the definitions I have provided you can see there are at least two dimensions going on:

![graph][fixme]

While I labeled (in parentheses) the x-axis as a spectrum from unit tests to integration tests—since that is how some people think about it—personally I like to avoid either term because they confuse the discussion.

> "According to the [test pyramid][test-pyramid] most tests should be unit tests. Abstraction X is a unit. Therefore we should write most tests at the level of abstraction of X."

This sounds like a reasonable appeal to best practices. The problem is that even if unit testing is a good idea and commonly practiced, there is no consensus of what a "unit" actually means. A unit might refer to X in one dev shop, Y in another, and Z in a third.<sup><a href="#note-2">2</a></sup>

Instead I prefer the terms "solitary" (testing in complete isolation) and "sociable" (testing multiple abstractions together). I think they capture the same idea without the baggage. You can read more about the terms [here][solitary-vs-sociable].

### What Makes A Good Test Suite?

Before we can talk about the relative merits of different styles of testing, we need to identify what makes a good test suite in general.

I think of the elements of a good test suite as a hierarchy:

1. __Trust__ – can you change some code, see the tests pass, and be confident<sup><a href="#note-3">3</a></sup> that you can release the change without introducing a bug?
1. __Speed__ – can you make a change and get feedback before getting distracted?
1. __Ease of Writing Tests__ – how easy is it for another dev to look at the testing style and quickly add/update tests for new behavior?
1. __Ease of Refactoring__ – how easy it to make changes to the implementation being tested? Do you have to update many tests? How confident are you that the refactoring is correct?

And when I say hierarchy, I mean a hierarchy. If you have not reached a threshold where you can trust your tests to tell you when a change has introduced a bug, you undermine the motivation for having automated tests at all. If devs are struggling to write new tests, then it does not matter how easy refactoring is, because you can't even introduce the new features that are the reason to refactor in the first place.

There are, of course, many other qualities that differentiate good test suites from bad. How high is the test coverage? How focused are the tests on testing one thing? How deterministic are test runs? How consistent is the code style? When a test fails, how helpful is the error message?

I would argue, however, that all the other qualities can either be included in one of the elements in the hierarchy above, or fall somewhere below the last element identified in the hierarchy.

Up to this point I have framed the question in terms of the result, the test suite, as if it were this static entity that can be evaluated on its own. If our goal is to evaluate testing styles, there is this whole other half to talk about: how the act of writing tests affects the design of the system under test. Don't worry, we will come back to that other half.

### How Do Different Styles Stack Up?

Because it is easier to think about concretely, for the rest of this section I'm going to talk about solitary vs sociable tests instead of the mockist vs classical styles. We already established they are not the same, but they go hand-in-hand often enough that I'm going to treat them as equivalent.

#### 1. Trust

A common claim against solitary-heavy test suites is, essentially, that you can't trust them:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Still love this one. Unit testers be like: &quot;Looks like it&#39;s working&quot; <a href="http://t.co/KiNT4wXP4a">pic.twitter.com/KiNT4wXP4a</a></p>&mdash; Kent C. Dodds (@kentcdodds) <a href="https://twitter.com/kentcdodds/status/628658648001048577?ref_src=twsrc%5Etfw">August 4, 2015</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

[This][solitary-no-trust-1] is a [common][solitary-no-trust-2] argument.

It is also 100% total __bunk__.

If your test suite is mostly solitary tests and you have too many integration bugs, then you are missing a few integration tests to fill in the gaps of the solitary tests. It doesn't mean solitary testing is bad. It means you are doing solitary testing *badly*.

Of course, you can also find the opposite claim—[that you can't trust sociable-heavy test suites][integrated-tests-scam]. More bunk.

There is something about the practice of ensuring program correctness that invites *hubris*. "The way I test my programs prevents bugs, therefore it is the only way to prevent bugs." Of course no one would say that. [But people believe it without realizing it][ideology].

Forget mockist vs classical styles of unit testing—__you don't need unit tests at all to prevent bugs__. Heck, you don't need any kind of automated tests. Now, that isn't to say you can avoid all structured discipline around verifying correctness. But the secret sauce of how testing prevents bugs isn't exactly the tests themselves. What is the secret sauce? Go read Michael Feathers' essay, [The Flawed Theory Behind Unit Testing][flawed-theory].

So no, I reject the claim that X is the one, true way to trust your tests.

#### 2. Speed

There is not much to compare here at the level of generalities.

In some times and places, sociable tests have a performance cost associated with setting up and running through multiple abstractions together. On the other hand, sometimes you need to write multiple solitary tests for what could be covered by a single sociable test.

I don't think it is fair to rule out either approach on the basis of speed until you get into the particulars of a specific situation.

#### 3. Ease of Writing Tests

This is a hard one to evaluate.

Mockists would tell you that it is simpler to think about every abstraction in isolation. If an abstraction needs to work with another abstraction, just implement a [tell-don't-ask][tell-dont-ask] interface between the two and you can mock the behavior easily.

Classicists would tell you that it is simpler to think about the black-box behavior of a logical group of components, rather than think about the implementation details.

My experience is that in most situations neither approach is significantly easier than the other. But in the cases where approach does make a difference, I find solitary testing to be easier than sociable testing more often than sociable testing is easier than solitary testing. YMMV, but let me share a couple examples so you know where I am coming from.

### Notes

1. <a name="note-2"></a> Heck, forget dev shop to dev shop, why not different definitions of "unit" from code base to code base or even within the same code base?
1. <a name="note-3"></a> I like the word "trust" because it leaves open the possibility that the object of trust could fail you. The goal of trusting your tests is not to prevent 100% of bugs. The goal is to have faith that your automated test suite is good enough. You have succeeded when the test suite fails to catch a bug and it is seen as a learning opportunity instead of a failure on the part of the dev.

[flawed-theory]: https://michaelfeathers.typepad.com/michael_feathers_blog/2008/06/the-flawed-theo.html
[ideology]: https://www.destroyallsoftware.com/talks/ideology
[integrated-tests-scam]: https://blog.thecodewhisperer.com/permalink/integrated-tests-are-a-scam
[mocks-arent-stubs]: https://martinfowler.com/articles/mocksArentStubs.html#ClassicalAndMockistTesting
[solitary-no-trust-1]: https://blog.kentcdodds.com/write-tests-not-too-many-mostly-integration-5e8c7fff591c
[solitary-no-trust-2]: https://www.thoughtworks.com/insights/blog/mockists-are-dead-long-live-classicists
[solitary-vs-sociable]: https://martinfowler.com/bliki/UnitTest.html#SolitaryOrSociable
[tell-dont-ask]: https://martinfowler.com/bliki/TellDontAsk.html
[test-pyramid]: https://martinfowler.com/bliki/TestPyramid.html
