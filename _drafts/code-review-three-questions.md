---
layout: post
title: "Three Questions To Ask When Giving a Code Review"
date: 2021-06-07
tags: code-review
---

Giving a good code review is something that a lot of devs struggle with. It is
not that most devs are incapable in my experience, more like they aren't sure
how much time to devote to it and what to focus on. Often times the first
things that jump out to us are the least important. Like have you ever seen a
review get caught up in a discussion of code style and all the while miss the
bug that was glaringly obvious in retrospect?

Being a little bit methodical can go a long way towards giving helpful code
reviews. I've come up with 3 focusing questions designed to hone in on the
essentials so you can leave a code review confidently without spending too much
time on it.

---

My assumption is you are working within an organization to leave written
feedback on someone else's Pull Request (PR) in something like the style of the
[GitHub flow][github-flow]. __Note:__ this isn't the only way to give a code
review, and indeed, we'll cover one alternative option later.

For each question below, you are going to want to review the entire PR, so by
the end you will have done at least 3 passes over the PR. It doesn't really
matter if you review commit-by-commit, review by looking at the entire diff of
changes, or review by looking at the final state of the affected files, so long
as you read over all the relevant code. If you notice something you might want
to leave feedback on—but it's not directly relevant to the current question you
are trying to answer—don't be afraid to jot down a note to come back to it
later.

#### 1. How does it work?

PRs often have 100s or 1,000s of lines of changes, yet the essential change can
often be pinpointed to a couple dozen lines of code or fewer, with everything
else being supporting details. Resist the temptation to dive into the first
thing that catches your eye—it is rarely the core of the change. Add a TODO
note and keep going until you have figured out what the essential changes are.
There is no point spending a bunch of time discussing some obscure point when
there are major design issues with how the overall PR works.

While you are figuring out how a PR works, don't forget to stop and ask if it
*does* work in the first place. I don't mean bugs—we'll get to that later—I
mean a PR can be logically self-consistent and do exactly what the author
thinks it does, and yet still be wrong. How do you know what it is supposed to
do? That depends on your organization, but typically there is a
Card/Task/Ticket associated with the work, or a requirements doc, or someone to
ask. Don't be afraid to check it.

Are you having trouble identifying how the change works? Even after looking it
for a while? Ask! Written questions on a PR can help future readers. While
reaching out for a face-to-face chat can help when you're unsure about the
right questions to even ask.<sup><a href="#note1">1</a></sup>

What about if you can't boil down the change to a couple dozen essential lines?
What if the PR really is doing a bunch of different things? The right move very
well could be to **not** leave a pass/fail review. It may seem weird at first,
but it's OK, I give you permission to try something different. Here are a few
alternative options:

1. Ask yourself if it was your PR how you would split it up into smaller
   reviewable+mergeable chunks. Reach out to the PR author to share your
   suggestions.<sup><a href="#note1">1</a></sup>
2. Split up the review task. It is unrealistic to try to properly review a too
   big PR in a single session. Plan for as many sessions as needed, and each
   time leave feedback on a part of the PR, following all the steps in this
   post each time.
3. Embrace the YOLO merge.<sup><a href="#note2">2</a></sup>

A final test: it is easy to finish a code review and think to yourself, “I
didn't see anything wrong, must be good.” Now imagine a junior coworker comes
to you right after you approve the PR and asks you to break down the change at
a high level, explaining what was changed and why. Could you do it? Without
looking at the PR?

#### 2. Where is the bug?

Very little code is bug free.

- we do separate passes because the mind is bad at looking at things critically

#### 3. How important is my feedback?

- automated lint rules

## Leave Feedback With Confidence

- don't be afraid to approve with qualifiers

## Notes

1. <a name="note1"></a> Most people
1. <a name="note1"></a> FIXME: check my blog post
1. <a name="note2"></a> Joking not joking. Sometimes the right business
   decision is to release a change without doing a proper review. The important
   thing is to explicitly acknowledge that—after weighing the options—you are
   choosing to forgo the usual code review process. Also YOLO merging doesn't
   mean you relinquish all responsibility for verifying the change. Even if
   it's not practical to review all the code, you can often substitute manual
   testing for code review, as a way to constrain the possible downsides of the
   change while only taking a fraction of the time.

[github-flow]: https://guides.github.com/introduction/flow/

