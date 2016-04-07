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

Besides, it's not like it's hard to run one merge command. You just have to remember to do.

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
off of `master` that feature branches can be merged into whenever a story gets
done. I like to call the branch that everything gets merged into the
"[integration][what-is-integration-branch]" branch.

![features-into-integration-diagram](FIXME)

Finally, when all the relevant features are merged into the integration branch,
you can do some final integration testing then merge the integration branch to
`master`.

![integration-into-master-diagram](FIXME)

Using an integration branch has other advantages as well. Because the code in a
feature branch (off an integration branch) won't be released until the complete
integration branch gets tested and merged, it's not as critical that the code
be fully tested before it gets merged. If you want, you can merge the feature
branch as soon as it's been code reviewed — you can always test the code after
it's been merged and the sooner it's merged the sooner you'll catch conflicts
with other feature branches.

A word of caution: with feature branches it's important to merge from `master`
into the branch on a regular basis. With integraiton branches it's even more
critical to merge on a regular basis because the probability of conflicts goes
up as the integration branch gets bigger and bigger over time.

Some advantages of an integration branch:

- Simple release strategy
  - The code gets released when and only when the integration branch is merged
  - Multiple related stories can be released simultaneously
- Easy to code review — all the relevant commits appear in the feature branch pull request

An integration branch works great when:

- Each story is cleanly partitioned so that no two stories will touch the same areas of the codebase
- There is at most one integration branch at any given time (having two or more large, long-lived branches sounds like a recipe for disaster)

### Refactoring Leads To Merge Conflicts

### Solution: Continuous Integration Branch

Everyone knows what "continuous integration" is, right? That's where you run
[Jenkins][jenkins] or [TeamCity][teamcity] on a server so it can build and test
your code every time a developer pushes some commits, right?

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
from sticking around longer than a single story. Personally, when working on a
team with a continuous integration branch, I like to use short lived branches
(< 1 day) as a staging area until I have a logical commit that I rebase onto
the integration branch.

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

†††† This could probably be automated with the right tool. I dream of a GitHub hook that runs on any commit to `master` (or any integration branch) and — using temporary scratch branches — attempts to merge the latest `master` commit into each feature branch. If the merge succeeds, the original feature branch is left untouched (to avoid filling the commit history with unimportant merge commits). If the merge fails, a comment is left on the pull request warning of the inevitable merge conflict. For bonus points, the hook could run the full automated test suite on each scratch branch and warn of any tests that will fail as a result of the merge.

††††† So long as you stick to merging — commands like cherry-pick, revert, and rebase can introduce non-obvious merge confilcts if you don't know what you're doing.

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
