---
layout: post
title: "Angular 1 Adoption Has Peaked: Are People Moving To Angular 2 Or React?"
date: 2016-11-6
tags: angularjs reactjs trends
---

At work we've got a large AngularJS codebase. It's on 1.x now. Someday we'll
either [upgrade the existing code to Angular 2][angular2-upgrade] or start
doing everything in React. __This post is not about your existing codebase.__
[Angular 1.x will be around and supported for a long time.][angular1-support]

However, we recently started a greenfield project. That meant choosing a tech
stack. And well... [choosing a frontend framework in late 2016 is interesting
to say the least][javascript-2016].  Since this new project will be around for
years (hopefully) we didn't want to choose a framework that is in the later
half of its lifecycle.

Make no mistake, __interest in Angular 1 is on the decline__—not just because
[Angular 2 is now officially released][angular-changelog]—but the data is clear
about it as well:

[![Graph of Angularjs questions on Stack Overflow][angular1-peak]][stackoverflow-trends]{: .center }

This graph plots the number of questions asked on Stack Overflow for the
`angularjs` tag (as a percentage of all questions asked) per-month. If that's
not enough to convince you, keep reading because the rest of the data I found
is consistent with this point.

### Choosing a Framework

When choosing a framework you need to consider first-and-foremost:

1. The requirements of the project
2. The technical merits of candidate frameworks
3. Everything else

I could go into the technical merits of Angular 2 vs. React, but I'm probably
among the least-qualified people to talk on the subject.

What I can talk about is adoption rates. Framework popularity may be lumped
into the "everything else" category, but it's still an important factor. It can
influence:

- How easy it is to find good documentation, answers on Stack Overflow, blog
  posts, etc.
- How quickly people report (and fix) bugs in the framework that may bite you
  some day
- How long your version of the framework will be supported

### Angualr 2 Vs React Adoption

If you search for "angular vs react" you may run across [this
post][learn-react-vs-angular] by Kamil Przeorski. The author has a React bias, but he posts some compelling data, including this graph of __technologies listed in Hacker News job postings over time__:

[![Graph of frameworks in job postings][hn-whos-hiring-graph]][hn-whos-hiring]{: .center }

We can learn a few things from this data:

- Backbone and Ember matter, but they're niche frameworks at this point
- Angular is firmly in the middle of the pack (across all technologies), but
  appears to have plateaued
- __More companies are interested in using React going forward and that number
  is on the rise__

While Hacker News may be representative of many startups and companies at the
leading edge of adoption, there is a large world of software development
outside of it. I think we need to get more data.

First stop, Google Trends:

[![Google Trends][google-trends-graph]][google-trends]{: .border .center }

Interest in React continues to grow, while Angular is still hugely popular but
maybe not growing in popularity. Google only gives us the very broadest strokes
(Angular vs React) though.

Looking at Reddit statistics, we can start to tease out interest in Angular 1
vs Angular 2 vs React by looking at the growth of the number of subscribers in
the respective subreddits:

[![Graph of subreddit growth][subreddit-growth-graph]][subreddit-growth]

That graph is a little noisy. The trends become clearer when we look at the
__total number of subreddit subscribers over time__:

[![Graph of subreddit subscriber totals][subreddit-totals-graph]][subreddit-growth]

React continues to show strong growth in interest. Interestingly, Angular 1
([/r/angularjs][r-angularjs]) interest appears to be plateauing, but when you
add in Angular 2 ([/r/angular2][r-angular2]) interest, the overall trend for
Angular may be increasing. It is hard to know though, since
[/r/angular2][r-angular2] growth may be driven by people still subscribed to
[/r/angularjs][r-angularjs].

Everything we've seen so far is a decent approximation for how many people
__want__ to use Angular or React. In the modern, open-source era though, we can
get more direct. __How many people are actually using the framework in real
world projects?__ While there is no survey of every real world project out
there, we have two good proxies: 1) issues and pull requests submitted to the
Github project, and 2) questions asked on Stack Overflow.

Sadly, I don't know of a tool that graphs the history of issues (or PRs) opened
on a Github project over time, so instead have this graph of __Github stars
over time__:

[![Graph of Github stars over time][github-stars-graph]][github-stars]{: .center }

What I can reveal to you is the complete graph from the beginning, __Stack
Overflow questions over time__ for all the relevant tags:

[![Graph of Stack Overflow questions][stackoverflow-trends-graph]][stackoverflow-trends]{: .center }

This graph plots the number of questions asked on Stack Overflow for the
different tags (as a percentage of all questions asked) per-month.

A word of caution about the graph: it is not a good idea to directly compare
frameworks by the absolute number of questions asked, since frameworks may
differ in the amount of features (more features = more questions) and the
quality of documentation (better documentation = fewer questions) among other
factors.

It is absolutely valid, however, to compare frameworks by looking at the growth
rate of questions. Doing so we can see that React is growing well (although
curiously plateauing in recent months, in contrast to all other data). But more
interestingly, we can see that __while Angular 1 is on the decline, adoption of
Angular 2 is strong and growing__.

A couple more notes on the graph:

- I included [Vue.js][vue.js], since it is the new up-and-coming framework, but
  as you can see it has not made large inroads yet
- Since Angular is kind of like React + Redux (+ a little more), I included the
  Redux tag so you can eyeball what an apple-to-apples comparison between
  Angular and React+Redux might look like


### So What Does It All Mean?

I could start by telling you what we adopted for the greenfield project at work
(React), but does it really matter?

In my uninformed opinion, both Angular 2 and React are solid frameworks on
their technical merits.

If you agree with my analysis of the framework adoption data, then you know
that both Angular 2 and React are strong and growing (looking at Stack Overflow
growth and jobs growth respectively).

My takeaway? __Pick whichever framework makes sense for your project and don't
worry about it.__ You're in good company whichever one you pick and don't let
anyone without data convince you otherwise.

[angular-changelog]: https://github.com/angular/angular/blob/master/CHANGELOG.md
[angular1-peak]: /assets/angular1-has-peaked-angular2-vs-react/angular1-peak.png
[angular1-support]: http://stackoverflow.com/a/37037365/27581
[angular2-upgrade]: https://angular.io/docs/ts/latest/guide/upgrade.html
[github-stars]: http://www.timqian.com/star-history/#angular/angular.js&facebook/react
[github-stars-graph]: /assets/angular1-has-peaked-angular2-vs-react/github-stars.png
[google-trends]: https://www.google.com/trends/explore?q=%2Fm%2F0j45p7w,%2Fm%2F012l1vxv
[google-trends-graph]: /assets/angular1-has-peaked-angular2-vs-react/google-trends.png
[hn-whos-hiring]: http://www.ryan-williams.net/hacker-news-hiring-trends/2016/november.html?compare1=AngularJS&compare2=Backbone&compare3=Ember&compare4=React
[hn-whos-hiring-graph]: /assets/angular1-has-peaked-angular2-vs-react/hn-whos-hiring-2016-11.png
[javascript-2016]: https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.75ybfocnk
[learn-react-vs-angular]: https://www.quora.com/Should-I-learn-React-or-Angular
[r-angularjs]: https://www.reddit.com/r/angularjs/
[r-angular2]: https://www.reddit.com/r/Angular2/
[stackoverflow-trends]: http://data.stackexchange.com/stackoverflow/query/572979/technology-trends-of-questions-per-tag-per-month
[stackoverflow-trends-graph]: /assets/angular1-has-peaked-angular2-vs-react/stackoverflow-trends.png
[subreddit-growth]: http://redditmetrics.com/r/reactjs#compare=angularjs+angular2
[subreddit-growth-graph]: /assets/angular1-has-peaked-angular2-vs-react/subreddit-growth.png
[subreddit-totals-graph]: /assets/angular1-has-peaked-angular2-vs-react/subreddit-totals.png
[vue.js]: http://vuejs.org/
