---
layout: post
title: "Add more context to your PRs"
date: 2023-01-14
tags: github code-review
---

The quickest way to get nit-picky feedback on a pull request (PR) is to add a two sentence description of *what* was changed and put it up for review. The best way to get good feedback on a PR is to equip the reviewer with the context needed to think more deeply about the change you are proposing.

<!--more-->
---

I will admit, I may go overboard with adding context. My PRs end up with more tie-ins than MCU movies. The motivation is largely self-centered—my memory is spotty and when I am inevitably asked about some change made 4 months ago, I don't like to get caught flat-footed. Along the way though, I discovered that making PRs a part of my exo-cortex has benefits--other benefits--that surpass the original motivation.

It makes sense, right? When the reviewer sees *what* was changed, but they don't really know *why*, they're still going to comment on *something*. Nobody wants to feel like they're a rubber stamp <img alt="rubber stamp" title="License: Creative Commons 4.0 BY-NC (https://pngimg.com/image/46067)" src="../../../assets/add-more-context-to-your-prs/rubber-stamp.png" height=26 width=26 style="margin: 0" /> reviewer. (…or do they? More on this in the next section.) So you get feedback about minor style issues that no one has gotten around to writing a lint rule for, or asking why you didn't do the obvious-but-subtly incorrect solution, or--and this is the one that uniquely burns me--you wrote a test description that was not 100% literally true about what the test was doing as if a robot were interpeting it. Sorry, that last one is a hill I have to die upon.

## Aside: Share more context upstream

Ready for an uncomfortable bit of truth?

<a href="https://twitter.com/fat/status/1602897307044745216"><img alt="screenshot of tweet suggesting a teams rubber stamp prs regularly" src="../../../assets/add-more-context-to-your-prs/a-teams-rubber-stamp.png" width="80%" /></a>

It has been my experience that on the small handful of top highly effective teams I've worked on, PRs got rubber stamped more often than not. Although to quibble about the explanation: Yes, there is a high degree of trust. But it is not trust that the other person never makes mistakes or trust that the person will never miss a good architectural opportunity. The trust is that they know how to use the basic tools of quality software engineering (clear code, types, tests, and judicious manual testing), so I as the reviewer don't have to look for obvious mistakes.<sup><a href="#note-1">1</a></sup> And the trust is that they'll get a spidey sense when there is some interesting decision to be made or unidentified solution to be found, which will get hashed out well before the PR goes up for review.

So the context is still there and it gets shared. But the magic of highly effective teams is that it all happens upstream of the PR.

**Do** look for opportunities to share context upstream.

**Don't** count on that alone being sufficient on most teams, even effective ones. Plus there are plenty of other benefits to writing up context on the PR--it adds visibility for other teams, and it can function as an architectural decision record.

## Practical Tips

So what does adding context to a PR look like? This is what I think about:

1. __Link to a card associated with the work__

    Sometimes cards are a placeholder, so it's not so helpful. But sometimes cards have easily overlooked requirements documented on them. If you set things up right, linking to the card can usually be done automagically, which gives you all the upside for free.

1. __Make sure the PR description hints at the *why*__

    Leave the *what* to your commit messages. By sharing the *why*, you empower reviewers to point out much better ways of achieving the same goal.

1. __If part of a larger set of changes, link to the previous PR and/or PRs in associated repos__

    Changes are very rarely made in isolation. When reviewers see the whole picture together, it is much easier to spot when the whole thing is a bad approach. Whereas if you are only reviewing a narrow slice it is too easy to tunnel in on whether the changes accomplish some narrow scope (while being counter-productive at a wider scope).

    Also, you don't have to go overboard with the links. Even if each PR only links to 1 or 2 other PRs, you can still end up with a web of connections that makes it easy to find all the relevant context with a few hops.

1. __Proactively add inline PR comments explaining decision points considered__

    In GitHub did you know that you can review your own PR? Take advantage of it to point out key things you've already thought about, rather than waiting for slow, asynchronous back-and-forth with reviewers.

1. __Document manual testing__

    Hopefully most of the work you do can be confidently shipped if the types and tests pass. However, I have worked in too many areas (frontends in particular) where it makes sense to do a quick manual pass.

    Don't spend much time on this. Keep it brief and high-level: "I tested X and it did the thing I expected Y". The reviewer isn't there to double check whether the manual test results look right, the reviewer is there to think about if any important testing was missed.

1. __Document paths you pivoted away from__

    When I write a bunch of code that I later realize is a bad approach, I used to commit the change and then immediately revert it. The goal was to communicate the path not taken, and why. However, reverted commits are not generally discoverable, plus it can introduce rebase headaches.

    There is a better way. Go ahead and commit the change with the abandoned approach. Except now, push it up in a branch, open a PR, write up brief notes why it is a bad idea, close the PR, and finally link to the closed PR from the PR you put up for review (on a different branch). It's not like there is a shortage of PRs or branches, so don't be afraid to use them. Much more discoverable and readable this way.

What tips did I miss? <a class="u-email" href="mailto:{{ site.email }}">Drop me a line</a> and if I get some tips I'll try to add a section for reader-submitted tips.

After you get in the habit of adding this kind of context, it takes little extra time. I put up a draft PR early in the development cycle, just so I can start adding notes right when I think of them. By the time the PR is ready for review, most of the documentation work on the PR is already done.

The end result is noticeably better software. More importantly, the end result is an end to annoyingly bad PR feedback, having been displaced by good feedback.

### Notes

1. <a name="note-1"></a> Instead of looking for obvious mistakes, I will think about what scenarios/tests that are not so obvious but might be absent.
