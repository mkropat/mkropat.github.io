---
layout: post
title: "Banish the word “nitpick” from code reviews"
date: 2024-01-12
tags: github code-review
---

<p style="text-align: center"><img alt="coworker nitpicking work" src="/assets/nitpick-code-reviews/nitpick.webp" style="width: 60%" /></p>

If there were a competition for who leaves the most pull request (PR) comments during code review, yours truly would be the winner.<sup><a href="/2024/01/12/nitpick-code-reviews.html#note-1">1</a></sup> Some of those comments are spotting immediate bugs or asking clarifying questions. Just as commonly however, the comments are optional naming suggestions<sup><a href="/2024/01/12/nitpick-code-reviews.html#note-2">2</a></sup>, discussion starters, and even--*gasp*--style feedback.

I have to bring all this up because--sometimes when people advocate for “no nitpick” reviews what they really want is a culture where PR review feedback is exclusively on function, with readability improvements considered out-of-bounds. That couldn't be further from the truth for what I am about to advocate. With *bona fides* out of the way…

**Don’t use the word "nit" in your code reviews.** Don't let your teammates use it either.

<!--more-->

The problem is that people get used to thinking of any optional feedback as a "nit." I especially see this from self-deprecating / non-confident / junior reviewers about their own feedback.

Once good but optional feedback is conflated under one word with trivial, bad feedback, the game is lost. Now reviewers are used to using the word "nit" and it provides cover for adding any random thought that crosses their mind while reviewing.

The new rule is:

> Reviewers are only allowed to leave feedback on details that the team agrees are important

A "nitpick" is **by definition** not important, Therefore you can't leave "nit" feedback under this rule.

*So am I just supposed to stop leaving naming suggestions and/or optional suggestions?* No, and no. I mean, really it depends on your team norms. However I would encourage you to consider readability feedback in-bounds.<sup><a href="#note-3">3</a></sup>

That being said, not all types of readability feedback are worthwhile.

## Out-of-bounds review feedback

The classic example of nitpick-y feedback is a line of code being too long, or perhaps disagreement about brace placement or whitespace or whatever else people get into flame wars about online.

It is not that these things don't matter for readability, simply that the styles people advocate for in practice are all within the same ballpark of readability (once you get used to the style). The real readability problem is inconsistent style, perhaps between different files but especially within the same file.

As many of you already know, the solution to issues of style<sup><a href="#note-4">4</a></sup> is to enforce a consistent style via linter rules. Once there is a pattern in place for setting up new linter rules (ideally for both off-the-shelf rules and custom coded ones), you can forbid review feedback about any matter of style that could just be a linter rule. If anyone takes issue with the style in a PR, it is on them to add a card to the backlog to set up a linter rule around the pattern.

Other examples of feedback to consider making out-of-bounds:

- Pointing out minor typos in comments (Suggestion: set up a spell checker to catch these as you type)
- Performance micro-optimizations
- Suggesting refactors with 0 rationale provided

## Be explicit about expectations

On some teams, "nit" is a synonym for "optional". This is bad, for reasons explained above. However, the part that is good is having an explicit convention for denoting which feedback requires addressing and which feedback is optional. The PR author should never be left guessing.

If you want to get explicit, you can break down required vs. optional for each feedback item even further:

- Merge blocking, must address in the current PR
- Non-merge blocking, but required to address as part of the same card (whether as part of the current PR or follow up PR)
- Non-merge blocking, but create a card to deal with later in the project
- Non-merge blocking, but create a card in the backlog to revisit at some point
- Good enough, but use a different pattern for future code
- Good code, and I want to leave positive feedback
- Question

The problem with tools like GitHub is that the code review UI makes only one thing explicit: whether the reviewer considers the whole PR changeset to be merge-able or not.

Your team probably doesn't need all the distinctions listed above, but it is worth having a conversation about what distinctions are meaningful for your team. Ideally you would also agree on a convention for how to denote which expectation applies for each feedback item. (Have you come up with a good convention? I would <a class="u-email" href="mailto:{{ site.email }}">like to hear about it</a>)

## Nitpicky-y feedback can be a symptom

I'd be remiss if I did a post on nitpick reviews and didn't go a level deeper. While it is worth establishing team norms around nitpick feedback, if you start seeing nitpick-y feedback on the regular, it is usually a symptom of an underlying issue.

#### 1. Lack of definition of reviewer responsibility

Has your team had a discussion about why you are doing code reviews? Established shared expectations about what what to look for? How long to spend on it?

It sounds too basic and yet, as a general rule, telling people:

> Focus on Y

Works a lot better than telling them:

> Stop thinking about X

For example, ask reviewers to first (in their head) answer the questions: what is the PR supposed to do? What is a two sentence description of how it achieves it? Only after they have an answer are they allowed to start focusing on smaller details. I am not saying you have to establish that specific rule, but hopefully that gives you an idea of the direction to go in.

#### 2. Bad PRs

It is easy to blame the reviewer for bad feedback, but maybe first turn your gaze on yourself (the PR author). Are you putting up PRs that don't give the reviewer enough to work with? I have a whole post over here on the subject: [Add more context to your PRs](/2023/01/14/add-more-context-to-your-prs.html)

#### 3. Slow cycle times

Story time! Two stories:

**First story**: you and a teammate are pair programming. The two of you are in a flow state, making quick work of the task. You finish writing writing the new function. Your pair suggests changing the name of one of the function parameters. You don't get it, so you ask them to explain their thought process. OHH, that's why. The rename will definitely avoid confusion down the line. You commit the change and put the work up for review.

**Second story**: you are solo coding. You finish writing the new function and push the branch up. It takes a while for the build to pass and verify that your change is correct. You create a PR and put the change up for review. Your team tends to be slow to review changes, so you pull a completely different card to start work on. Next week your teammate submits a code review requesting changes--they don't like the name of the function parameters. Why are they wasting your time with this trivial stuff? Don't they know that it will take an hour out of your day to stash what you are in the middle of, switch to the old branch, make the change, then babysit to make sure the build passes. It can't possibly be worth it.

Same code review feedback--two completely different reactions.

I'm not saying everyone should pair all the time. There are too many trade-offs to make a blanket recommendation like that. Nor am I suggesting that you have to solve an intractably slow build before considering small readability feedback in-bounds.

What I am suggesting is to be mindful of the viewpoints of both the reviewer and the recipient. It can be simultaneously true that:

1. In a healthy work environment, the time needed to address the reviewer's feedback would pay for itself many times over
2. Given specific dysfunctions in the current environment, it may not be practical or worth it to make every suggested change

Take the team's frustrations with the review process and channel it into addressing the underlying problems that are leading to these nitpick-y reviews in the first place.

### Notes

1. <a name="note-1"></a> OK, maybe not every single team I've been on, but most of them.
1. <a name="note-2"></a> Naming matters! I once took a file that for whatever reason had a bunch of 3-word variable names--each individually well named but collectively forming a verbose word soup--then I renamed them all to 1-2 word variable names and the difference to the file was night and day. It was suddenly easy to see the flow of what was happening in the file.
1. <a name="note-3"></a> Trying to read and understand code after-the-fact is hard, whether that is to answer a question about its behavior, investigate a bug, or figure out how to extend the behavior. Investing, say, 10% more time up-front on readability improvements can pay large dividends down the road, this is sometimes the case even if you only revisit the code a single time. (If the code is literally never revisited, then yeah, it was wasted effort, but that is pretty rare in my experience.)
1. <a name="note-4"></a> Strictly speaking, linter rules are a good solution to many (but not all) style issues. Not every pattern that falls under the term "style" is amenable to easy AST matching and transformation.
