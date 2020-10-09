---
layout: post
title: "Make Your Commit Messages Inversely Proportional To Diff Length"
date: 2020-10-09
tags: git
---

You'd think based on the title that this post is about commit messages. It's not. At least, not really.

What I want to reflect on is how we go about grouping changes into a commit
history. It is my opinion that some styles are better than others. And if you
agree with my style, you too might find that your commit messages are inversely
proportional to the length of the commit diff.

<!--more-->

---

So let's talk about commit grouping. We've probably all seen commit history that looks like this:

```
e84b8e0 Address more feedback
5cb6d9b Address feedback
3acaf21 Fixes to get build to pass
bbba1eb Fix typo
4c3515f Add tests
896768b Implement feature
```

(Like `git log`, this history goes from oldest at the bottom, to most recent at the top.)

If you took a programmer who had never used a version-control system before, gave them the git tools—without teaching how they should use them—this is probably what they would come up with. And there's nothing wrong with it, depending on what you're trying to accomplish.

This commit history represents snapshots of the actual steps the programmer took to arrive at the final code. Let's call it the "ratchet" style of history, after the mechanical device that allows one-way movement and can save progress.

[![diagram of a ratchet mechanism][ratchet-image]][ratchet-image-source]

I use this style of committing all the time. I don't know about you, but I get incredibly nervous when I have multiple changes (perhaps split across many files) that I haven't committed. Sure, there is your editor's save and undo ability, but you only have to be burned a few times—trying to undo back to the last working state, not sure when you've gone back too far—to mistrust editor time travel. Using commits to save snapshots of your progress at regular intervals is much safer.

Still, it is not hard to see limitations with the ratchet style. For instance: if I were to personally walk someone through the code I've touched, like during a code review, would I repeat the exact series of steps I originally made when writing the code? Perhaps, on rare occasion. But most of the time? Probably not. No need to go over the silly false steps.<sup><a href="#note1">1</a></sup> No need to be constrained by your original understanding, which could very well have changed.

Yet, that is what we do when we ask someone to do an asynchronous code review on a PR featuring commits in the ratchet style. It is also the history we are presenting to far future readers wondering why the heck the code is the way it is. Or maybe not even readers, per se, but someone doing a `git bisect` through the history and would like every commit to represent a working, green build. I think the prevalence of the ratchet style along with an acknowledgement of these concerns is what leads people to the "Squash and Merge" pattern of collapsing branch history on merge.<sup><a href="#note2">2</a></sup>

What I'm about to say will be obvious to some of you… still I bet this idea will be new to some readers: __just because you commit your work-in-progress using the ratchet style, that doesn't mean that the commit history you present to others has to be in the ratchet style.__

## The Freedom of Git Rebase

Git, in contrast to many previous version control systems, makes editing the commit history a first class concept. Typically this is accessed through the `git rebase` command.

This blog post is not a How-to on editing commit history with `git rebase`. Instead, I hope to convey a sense of high-level style for what grouping of changes makes a good commit. Figuring out how to mechanically stage those commits—especially after-the-fact when the bulk of the changes have already been made to your working copy—is an exercise left to the reader.

Perhaps the most common style of edited history I see looks like this:

```
b945bb0 Update another component
0616b8a Update some component
4049f83 Update supporting component
```

Gone are the "fix typo" commits. Changes to test files are grouped with changes to the (corresponding) implementation in the same commit. The overall change is broken down and the reviewer is guided through a series of smaller changes, "OK, first look at this file, now look at this file, etc.".

Let's call this the "file-granular" style of commit history, since related files are committed together (test + implementation), while on the other hand, different changes to the same file are rarely split into separate commits. It is easy to see why people start with this style: it has some advantages over the ratchet style and it requires minimal skill in editing history to achieve.

## The Road To Better Commit Grouping

When reviewing code it is usually most efficient to focus on the specific lines that were changed, on the assumption that the rest of the pre-existing code is good enough.<sup><a href="#note3">3</a></sup> And so, if you have ever reviewed a change where someone moved pre-existing code around *and* changed some of that moved code in the same commit, you know that the file-granular style can be frustrating to review. The person who made the change knows, "oh, I just moved this block from here to there and changed these two lines." But the reviewer doesn't know that. The reviewer has to tease that information out after-the-fact, which can be time consuming.

The "move then make a change" problem has a more general principle hiding in it: __don't group refactoring changes in the same commit as intentional behavior changes__. When you split refactors into separate commits from intentional behavior changes it makes it easy for reviewers to provide better feedback, "I see this is supposed to be a refactor… did you mean to delete the user account here when we weren't doing that before?" Plus it calls out intentional changes worthy of getting eyes on that might otherwise be overlooked.

Here are some more suggestions:

- Don't group fixes with new functionality
- Don't group story/task changes with changes of your own initiative
- Don't group auto-generated/tool changes with manual code changes
- Don't group controversial changes with boring changes

Take my grouping suggestions with a grain of salt. I don't know if they apply in every situation, but they seem to serve me well.

The broader point is that there is a third style when it comes to commit history. Let's call it the "logical change" style, or "logical" for short. While we might disagree on the specifics of what makes a good grouping, what makes it a style distinct from the file-granular style is that we are grouping changes first and foremost by principle or intent, with considerations like what file those changes happen to be in a distant second.

What might a commit history in the logical style look like?

```
e90cffb Implement feature Z
efb2c5a Extract component X from Y
1ed0350 Fix warnings
```

Gone are the vague commit messages, "Update some component".<sup><a href="#note4">4</a></sup> Suddenly it is easy to think up specific commit messages because the commit no longer represents a grab bag of possibly unrelated changes. The verbs in particular become very easy to choose.

#### So you want me to have dozens of commits on a PR?

No. Please don't do that.

It is not uncommon for a single one of my commits to have hundreds of lines added or changed. I do a lot of front-end work and sometimes when working on a new feature I will add new screens with lots of corresponding markup. When the code is fairly rote and it is all specific to adding the new feature (or whatever you are working on), I see no problem with combining it in a large commit.

But what about when you have lots of changes and they don't logically group together? Cause that definitely happens.

So here's the thing… is it possible you are trying to make too many changes in a single PR? Big PRs—especially PRs with many logically distinct changes—are hard to review well. It's easy for bugs to slip through. And if all the changes get released at the same time, it makes it harder to identify the cause when bugs do happen.

Don't be afraid to split a feature branch that is getting too large into multiple, smaller PRs. <sup><a href="#note5">5</a></sup>

## On Commit Message Length

So what does commit grouping have to do with commit message length?

We have already seen why you might group, say, a controversial changes into its own commit separate from other, boring changes. This hints at differences in commit message length. If you'll allow me to make one more observation: well written code often speaks for itself, along with the corollary—having a larger volume of well-written code communicates more than a smaller volume of code.

Imagine you are writing a fix for a bug. Sometimes the bug is because the problem is more complex than the original, simple solution anticipated. In that case the fix is probably going to involve a non-trivial amount of code. And that code will probably explain on its own how the new solution works. Sure, perhaps you might use the commit message to document why the original solution was lacking,<sup><a href="#note6">6</a></sup> but you don't have to explain the solution as much.

Now imagine the bug is really subtle. Like the order of two operations needs to be swapped, or perhaps you are passing the wrong flag to an API. The fix could be really short, like a one-line or sometimes even a one-character change, plus perhaps a new unit test. If it was obvious why the fix was needed, the original programmer (or reviewers) probably would have caught it back then. No, a good commit message is probably warranted to explain not just what the problem with the original code was, but also an explanation why the fix truly solves the problem.

I bring up the example of a bug fix, but it is more than just fixes. The types of changes that require a lot of documented context tend to be precisely the changes you want to pull out into their own commit. That is how you end up with long commit messages on short diffs and short messages on long diffs.<sup><a href="#note7">7</a></sup>

---

Thanks for sticking with me this far. If you don't already practice making your commits in the logical style, hopefully this post has given you something to consider.

## Bonus Content: On Commit Ordering

Sometimes the ordering of commits is a strict dependency graph. Like if I have one commit that introduces a helper component, and another commit that relies on that helper component, there is only one option for ordering.

Other times the different commits represent completely independent changes. In which case ordering only matters to help future reviewers/reviewers.

But often times ordering is important and there is a choice. For example, if I want to refactor some existing code to make another change nicer, I could do the refactoring, then make the change. Or I could make the change, then do the refactoring.

Here is my advice: __put riskier changes later__.

By "risky" I mean changes that fall into one or more of these categories:

- Likely to get feedback asking for changes
- Likely to be deferred to a future PR
- Likely to be axed entirely

Why? Because I like to maintain a clean commit history, even as a feature branch evolves (for example: in response to code review feedback).<sup><a href="#note8">8</a></sup> And when you have to make changes earlier in the commit history it can necessitate follow-on changes to later commits. More changes leads to more work and more opportunity for bugs.

### Notes

1. <a name="note1"></a> Some false steps are worth committing! If it is not immediately obvious why one approach is a bad idea until you try it, committing the attempt then immediately reverting the commit is a form of documentation left in the history for future readers.
1. <a name="note2"></a> If I were to create a tier list it would go something like: (pleb tier) ratchet style history / (decent tier) squash and merge / (enlightened tier) thoughtful commit history w/o squashing.
1. <a name="note3"></a> This isn't always a safe assumption, admittedly. Sometimes the pre-existing code has glaring issues. Also, the diff of lines that were changed doesn't show you changes that were not changed but perhaps should have been. So sometimes it is important as a reviewer to familiarize yourself with all the surrounding code. But hopefully not too often, as it can be time consuming.
1. <a name="note4"></a> Or even better, gone are specific yet *misleading* commit messages.
1. <a name="note5"></a> Indeed, there is a cool workflow you can do which involves working locally on a big feature branch, regularly splitting off smaller, reviewable PRs that can be merged into the main branch, which then serve as the rebase target for the local feature branch. It avoids some of the downsides of doing complicated work in really small chunks, while still making sure the changes get integrated with the main branch on a regular basis, as well as having easy to review PRs. Perhaps the subject of a future blog post.
1. <a name="note6"></a> And even then, the explanation could be redundant since it's likely either called out in the story/task description or described by a unit test added alongside the fix. Still, adding the explanation to the commit message rarely hurts and can sometimes help.
1. <a name="note7"></a> I can think of at least one exception to the rule that long diffs have short messages: when you are implementing a new feature and there are multiple approaches that could have been taken, it is natural to have a big diff while still wanting to have a long explanation for why one approach was chosen over another. And it's definitely fine to have a short message with a short diff when the context is obvious. I think it would be a mistake to treat "make your commit messages inversely proportional to diff length" as a hard rule. I make the statement as an observation that if it holds true on average you are probably doing it right, and as a rhetorical trick to help reconsider old habits.
1. <a name="note8"></a> If you don't edit history past a certain point, like after the code is put up for review, perhaps my advice does not apply.

Shout out to my employer, [Root Insurance][root-engineering], for giving me hack day time to work on this blog post.

[ratchet-image]: /assets/make-commit-message-inversely-proportional-to-diff-length/Sperrklinke_Schema.svg "By Georg Wiora (Dr. Schorsch) - Vectorised and reworked by Dr. Schorsch with Inkscape, CC BY-SA 3.0"
[ratchet-image-source]: https://commons.wikimedia.org/w/index.php?curid=384742
[root-engineering]: https://root.engineering/
