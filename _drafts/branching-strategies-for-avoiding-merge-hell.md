---
layout: post
title: "Branching Strategies For Avoiding Merge Hell With Git + GitHub"
date: 2016-02-13
tags: ci git github
---

There is a lot of advice out there when it comes to using branches with git,
but I haven't seen much in the way of advice that:

1. Works on teams of ~4-8 people, that…
2. Takes advantage of [Pull Requests][github-pull-requests] and [Issues][github-issues], and…
3. Makes it easy to do [code reviews][code-reviews], and…
4. Keeps `master` deployable at all times, even when…
5. Everyone is touching the same areas of code, all the while…

__Avoiding time-consuming merges and difficult-to-resolve merge conflicts__

In short, I want to help you not end up like this:

![git guitar hero](https://twitter.com/HenryHoffman/status/694184106440200192)

<!--more-->

### Pull-request Workflow

Let's start from square one. The typical workflow we use on our team for a
simple, standalone [story][user-story] looks like this:

![simple-feature-branch]()

When a developer starts work on a new story, they create a local [feature
branch][feature-branches] (or ["topic branch"][topic-branches] in git parlance)
off of the latest `master` branch. Any code changes they make are committed to
the feature branch and pushed up to `origin`.  After the code has been pushed,
the developer creates a pull request from the feature branch into the `master`
branch.

![pull-request-screenshot]()

__Note__: we use [GitHub][github] at my work so that's what all the examples
will be using, but the strategries should apply equally well to any tool that
supports Pull Requests and Issues.

When coding is complete, another developer reviews the changes and leaves their
comments on the pull request. If any issues are found, the fixes are applied to
the feature branch. When everyone is satisified, the pull request is merged to
`master` and the feature branch is deleted. Once code — any code — is merged to
`master` it is considered production ready and will be included in the next
release.†

__Common Misconception__: creating a pull request does __not__ require
[creating a fork][github-fork].††

None of this is likely to be surprising if you've worked with pull requests
before. However, if you want to learn more, there are a number of great
tutorials that cover the pull request workflow in great detail.

Some advantages of the pull request workflow:

- Easy to code review — all the relevant commits appear in the pull request
- Simple release strategy — the code gets released when and only when the pull request is merged

The pull-request workflow works great when:

- Work on no other story will be touching the same areas of the codebase
- No other feature branch needs to include commits from the pull request before
  the pull request is merged to `master`
- The code can be released with little-to-no coordination with any other story

### Best Practice: Frequent Merges From Master

But this post is about avoiding merge hell, right? Here's your first tip to
avoid it:

__Merge early and often from `master` into any feature branch that lives longer
than a day.__†††

![simple-feaeture-branch-with-merge]()

If you follow the rest of the advice in this post, merge conflicts are going to
be unlikely, but sometimes it's going to happen anyway.  The sooner you
discover a conflict then the sooner you can resolve it and the less time you
spend writing code that compounds the conflicts.

Besides, it's not like it's hard to run one merge command. The hardest part is
making it a habit.

Also worth mentioning is that in addition to merge conflicts there are also
[semantic conflicts][semantic-conflicts].  These won't be caught by any tool.
They can only be caught by testing or manual review of the code.

To minimize the risk of both types of merge issues, I recommend:

1. Once a day, before continuing work on an existing feature branch, merge `master` into the branch††††
2. Merge `master` into any feature branch before you start a code review or acceptance test

### Mayan Pyramid Of Doom

Pop quiz: what happens when a second merge is done in the following scenario?

![merge quiz]()

In some version control systems, the second merge [will result in a merge
conflict][svn-merge-conflict] because the first commit will be applied again
even though it already exists in the destination branch. So what about git?
Will the second merge introduce a conflict?

Nope. Git is smart about merging branches with a shared history. No matter how
many branches you have and no matter how many times you merge any branch with
any other branch, git will never introduce a merge conflict by attempting to
re-apply a commit that already exists in the destination branch's history.†††††

Because git is so smart, it introduces a new way to shoot yourself in the foot,
and I'm going to tell you a story about it.

It all starts innocently enough:

![pyramid-base]()

Our first developer, Ada, starts work on `some-feature` just like in the pull
request workflow.

Ada's coworker, Charles, wants to start work on `second-feature` but realizes
his change depends on some of the code Ada wrote for `some-feature`.  Since Ada
is more or less done with `some-feature`, Charles creates the `second-feature`
branch by branching off of `some-feature`:

![pyramid-1]()

This seems fine. We already know that merging `second-feature` to `master`
won't cause a merge conflict even if `some-feature` has already been merged to
`master`. And as far doing the code review on `second-feature`, since we know
that `some-feature` will be merged to `master` soon, we can just create a
second pull request from `second-feature` into `master`. At first, the
`second-feature` pull request will contain all the commits of `some-feature`,
which will be confusing, but once the `some-feature` pull request is merged to
`master`, those commits will disappear from the `second-feature` pull request
like we want.

However, while waiting for a code review on `some-feature`, Ada stars work on
`third-feature`, and since it depends on code in `second-feature` she creates
her new branch like so:

![pyramid-2]()

At this point, the pattern has been established. When coworkers Douglas and
Grace free up on other tasks, they jump in to help on the project with
`third-feature` and `fourth-feature`:

![pyramid-4]()

The final complication: Ada and Charles assumed that `some-feature` would be
merged to `master` before `second-feature`. But it turns out after discussion
that we don't want to release any of the related features until they've all
been tested together.  So much for code reviewing each story using a pull
request from the feature branch to `master`.

Without forethought, it's easy to end up with what my coworker [David
McGrath][david-mcgrath] dubs the Mayan Pyramid of Doom:

![mayan-pyramid-of-doom]()

(Not to be confused with the [other pyramid of doom][callbacks-pyramid].)

### Solution: Feature Toggles

![what-if-told-you-you-can-live-in-a-world-without-merge-conflicts][fixme]

How?

It's simple: stop using branches.

No branches means no merge confilcts, unless two developers are literally
working on the same code at the same time.

Believe it or not, that's what most developers did in the early days of version
control, back [before sane merging of feature branches had been
invented][svn-merge-tracking].

You might be thinking, "that's the dumbest idea I've ever heard." After all,
there was a reason why we started using branches. How do you do code reviews?
How do you prevent features from being released before they're ready? How do
you keep `master` stable and deployable at all times?

The first question I'll tackle later in this post. For now, I want to talk
about a simple solution to the other two questions.

Imagine we want to add a new widget to the UI called `Bar`. Instead of
committing a change that looks like:

```javascript
 function loadApp() {
   loadWidgetFoo();
+  loadWidgetBar();
   loadWidgetQux();
 }
```

Imagine if we committed a change that looked like:

```javascript
 function loadApp() {
   loadWidgetFoo();
+  if (isFeatureEnabled(Features.BarWidget)) {
+    loadWidgetBar();
+  }
   loadWidgetQux();
 }
```

Elsewhere we could have a configuration file or database table that toggles
`Features.BarWidget` on or off. That is the idea behind feature toggles in a
nutshell. Basically it's a way of using code to control what code gets
"released" instead of relying on the version control system.

I don't want to spend too much time talking about feature toggles though, because
this post is supposed to be about branching strategies, right? Besides, there's
already a bunch of good info out there about feature toggles.

The important takeaway for now is the idea that there are alternatives to the
simple pull request workflow, and that there might not be one best strategy for
all situations.

Some advantages of feature toggles:

- Minimal chance of merge conflicts — everyone can work in a single branch
- Simple release strategy — the code gets released when and only when the feature toggle is turned on

Feature toggles work great when:

- The code that you're touching can be easily wrapped in one or more conditionals

### Solution: Merge To Integration Branch

There's a simple fix for the Mayan Pyramid of Doom: create a dedicated branch
off of `master` to contain the changes for all the stories that need to be
released together. For convenience, we'll call this dedicated branch an
"[integration][what-is-integration-branch]" branch.

You still develop in feature branches and you still create pull requests for
code review. The only difference is that instead of creating a pull request
from the feature branch into `master`, you create a pull request from the
feature branch into the integration branch.

![features-into-integration-diagram](FIXME)

Finally, when all the relevant features are merged into the integration branch,
you can do some final integration testing then merge the integration branch to
`master`.

![integration-into-master-diagram](FIXME)

__Pro Tip:__ As soon as you're done the code review on a feature branch, go
ahead and merge it into the integration branch. Any sort of manual/acceptance
testing can be done later off of the integration branch†††††††. The idea is to
reduce the chance of merge conflicts by reducing the amount of time feature
branches stay unmerged.

__Warning:__ with feature branches it's important to merge from `master` into
the branch on a regular basis. With integraiton branches it's doubly important
to merge on a regular basis because the probability of conflicts goes up as the
integration branch diff gets bigger and bigger over time.

Some advantages of an integration branch:

- Simple release strategy
  - The code gets released when and only when the integration branch is merged
  - Multiple related stories can be released simultaneously
- Easy to code review — all the relevant commits appear in the feature branch pull request

An integration branch works great when:

- Each story is cleanly partitioned so that no two stories will touch the same areas of the codebase
- There is at most one integration branch at any given time††††††
  - (Having two or more large, long-lived branches sounds like a recipe for disaster)

### Can't We Just Plan Stories Better?

Are we tackling the wrong problem? Maybe we could get better at dividing up and
sequencing stories so that no two stories will ever be pulled in at the same
time that require changing the same areas of code. No overlapping changes means
no merge conflicts.

Answer: no.

I don't discourage anyone from trying to improve their planning, but it's a bad
idea to rely on planning to prevent overlapping changes in differnet stories,
and that's not just because fortune telling is notoriously hard.

The reason is refactoring. When you make changes, it's inevitable you will
outgrow the existing abstractions in your code. A good programmer notices this
and changes the abstraction so that both the new and the existing code makes
sense together. The problem with this kind of refactoring is that it tends to
involve changing code in lots of places outside of the areas strictly required
for the story you're working on. Normally this isn't a problem because you have
automated tests to prevent accidental regressions. But it becomes a problem
when the changes from the refactoring overlap with changes in a feature branch
on another story.

So you're left with one of two outcomes:

1. You proceed with the refactoring that does cause a merge conflict later on, which is what we're trying to avoid, or...
2. You fear that any given refactoring may cause a merge conflict later, so you don't do it, which in the long run can be even worse than the occasional merge hell

### Solution: Continuous Integration Branch

Everyone knows what "continuous integration" means, right? That's where you run
[Jenkins][jenkins] or [TeamCity][teamcity] on a server so it can build and test
your code every time a developer pushes some commits, right?

That is, no doubt, a highly useful practice. It may be illuminating, however,
to look at how the Extreme Programming movement (a precursor to today's Agile)
defined "continuous integration" back in 1996:

> Developers should be __integrating and commiting code into the code
> repository every few hours__, when ever possible. In any case never hold onto
> changes for more than a day.

and

> Continuous integration avoids or detects compatibility problems early.
> Integration is a "pay me now or pay me more later" kind of activity. That is,
> if you integrate throughout the project in small amounts you will not find
> your self trying to integrate the system for weeks at the project's end while
> the deadline slips by. Always work in the context of the latest version of
> the system.

(Emphasis mine.)

At the time, that advice was aimed at developers who kept changes on their local PC days or weeks at a time before pushing.

### A More Nuanced View

The point of this post is not to sell you on the one true branching strategy
for git.  In fact, I hope I've led you to the opposite conclusion: there are
multiple viable strategies for avoiding mege problems and that each strategy
has its own tradeoffs.

In practice, there are way more strategies than I've mentioned, if for no other
reason than that you can combine any of the above strategies in different ways.
For example, many people use feature toggles in conjunction with feature
branches so that you get the code review benefits of feature branches while
preventing any branch (even if the associated code is not ready to release)
from sticking around any longer than a single story. A personal example is that
when working on a team with a continuous integration branch, I like to use
short lived branches (< 1 day) as a staging area until I have a logical commit
that I rebase onto the integration branch.

### tl;dr

There are

### Bonus Content: Michael's Guide To Merge vs Rebase Hygiene

Some might argue that the genius of git is that it implements a complete
version control system out of little more than a Merkle tree of three simple
data structures: commits, trees, and blobs.

While all that's true, I think it misses the far greater contribution that git
has brought to the world: in an era with too few unwinnable nerd debates — [.gif
vs .gif][gif-vs-gif], [tabs vs spaces][tabs-vs-spaces] — git breathes new life
into the genre with: [merge vs rebase][merge-vs-rebase].

If the words "merge vs rebase" mean nothing to you, then you can probably skip
this section and continue to live your life happily.

But if the readability of your commit history is something you're optimizing
for, that's cool too. Whether you merge or rebase is largely orthagonal to the
strategies presented in this post. In this post I give instructions that follow
the merge method because it's easier to explain.  However, while reading along
in your head, feel free to:

- Replace:

  > merge from `master`/`integration-branch` into `feature-branch`

  with:

  > rebase `feature-branch` on to the latest `master`/`integration-branch`

- And replace:

  > merge pull request into `master`/`integration-branch`

  with:

  > squash `feature-branch` into one or more logical commits and fast-forward merge `master`/`integration-branch` to it

  (but only if you're obsessed with linear history)

Personally I rebase when it's easy (and guaranteed to not mess anyone else up),
while the rest of the time I just merge. Having a clean, linear history is nice
but it's rare that I look at it. Most of the time FIXME

### Notes

† That isn't to say you shouldn't perform additional testing — whether automated or manual — before releasing new code in `master`. We run through our full automated test suite, in addition to doing manual smoke tests on the features that are being released, to try and ferret out any issues arising from running the new code in the production environment (as opposed to the dev environment).

†† In open source work — where contributors typically don't have push access to the canonical repo — creating a fork is necessary so contributors can push their changes somewhere. In team environments, typically everyone has push access to a single repo, so forking isn't necessary.

††† Before you object with, "always rebase instead of merge", please read [Michael's Guide To Merge vs Rebase Hygiene]().

†††† This could probably be automated with the right tool. I dream of a GitHub hook that runs on every commit and — using temporary scratch branches — attempts to merge the commit with every other feature branch. If the merge fails, a comment is left on the associated pull requests warning of the inevitable merge conflict. For bonus points if the merge succeeds, the hook could run the full automated test suite on each scratch branch and warn of any tests that will fail as a result of the merge.

††††† So long as you stick to merging — commands like cherry-pick, revert, and rebase can introduce non-obvious merge confilcts if you don't know what you're doing.

†††††† The one exception to this rule is when the group of stories you are working on will span multiple release milestones. Then you might have to create `milestone-1` and `milestone-2` integration branches for the differnet releases. The important thing is that you merge `master` into `milestone-1` and merge `milestone-1` into `milestone-2` frequently. Later you might have to create a `milestone-3` integration branch, but by that time hopefully `milestone-1` will have been released and merged to `master`, so in practice you shouldn't need to have more than two milestone integration branches alive at any given time.

††††††† Or a snapshot (tag/branch) off of the integration branch if you're having trouble with the integration branch being too moving a target.

#### References

[advice-1]: http://blogs.atlassian.com/2014/02/trust-merge-branch-simplification-musings/
[advice-2]: http://codeinthehole.com/writing/pull-requests-and-other-good-practices-for-teams-using-github/
[advice-3]: https://about.gitlab.com/2014/09/29/gitlab-flow/
[advice-4]: https://www.atlassian.com/git/tutorials/comparing-workflows
[advice-5]: https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows
[advice-6]: https://gist.github.com/jbenet/ee6c9ac48068889b0912


[github]: https://github.com/
[github-fork]: https://help.github.com/articles/fork-a-repo/
[github-pull-requests]: https://help.github.com/articles/using-pull-requests/
[github-issues]: https://guides.github.com/features/issues/
[code-reviews]: http://blog.codinghorror.com/code-reviews-just-do-it/
[user-story]: https://en.wikipedia.org/wiki/User_story
[topic-branches]: https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows#Topic-Branches
[feature-branches]: http://martinfowler.com/bliki/FeatureBranch.html
[gif-vs-gif]: https://www.nsfwcorp.com/dispatch/wwg/
[tabs-vs-spaces]: http://cube-drone.com/comics/c/junior-programmer-presentations
[merge-vs-rebase]: https://news.ycombinator.com/item?id=6456390
[semantic-conflicts]: http://martinfowler.com/bliki/SemanticConflict.html
[svn-merge-conflict]: http://svn.gnu.org.ua/svnbook/svn.branchmerge.copychanges.html#svn.branchmerge.copychanges.bestprac.track
[jenkins]: http://jenkins-ci.org/
[teamcity]: http://www.jetbrains.com/teamcity/
[david-mcgrath]: https://twitter.com/mavtak
[svn-merge-tracking]: http://blog.red-bean.com/sussman/?p=92
[what-is-integration-branch]: http://stackoverflow.com/q/4428722/27581

#### Bibliography

- http://weblogs.asp.net/fredriknormen/merge-hell-and-feature-toggle
[code-reviews-conventional-wisdom](http://programmers.stackexchange.com/questions/121664/when-to-do-code-reviews-when-doing-continuous-integration)
- http://programmers.stackexchange.com/questions/187512/is-a-merging-strategy-like-git-flow-really-an-anti-pattern/187520#187520
- http://martinfowler.com/bliki/FeatureBranch.html

how git works:

- http://wildlyinaccurate.com/a-hackers-guide-to-git/

rebase:

- http://www.jarrodspillers.com/git/2009/08/19/git-merge-vs-git-rebase-avoiding-rebase-hell.html
- http://www.tugberkugurlu.com/archive/resistance-against-london-tube-map-commit-history-a-k-a--git-merge-hell
- http://kentnguyen.com/development/visualized-git-practices-for-team/

- continuous integration with feature toggles instead of feature branches - http://geekswithblogs.net/Optikal/archive/2013/02/10/152069.aspx
