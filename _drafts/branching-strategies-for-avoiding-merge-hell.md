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
3. Makes it easy to do [code reviews][code-reviews], where…
4. Everyone is touching the same areas of code (even when working on different stories), and…
5. Supports releasing different features at different times, and yet somehow…
6. Avoids time-consuming merges and difficult-to-resolve merge conflicts

In short, I want to help you avoid this:

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
- No other feature branch needs to include the commits in the pull request
  before the pull request is merged to `master`
- The code can be released with little-to-no coordination with any other story

### Best Practice: Frequent Merges From Master

But this post is about avoiding merge hell, right? Here's your first tip to
avoid it:

__Merge early and often from `master` into any feature branch that lives longer
than a day.__†††

![simple-feaeture-branch-with-merge]()

If you follow the rest of the advice in this post, your pull request shouldn't
be touching the same code as any other recently merged pull request, so merge
conflicts are unlikely, but somtimes it's going to happen anyway. The sooner
you discover a conflict the sooner you can resolve it and the less time you
spend writing code that compounds the conflicts.

Perhaps more dangerous than merge conflicts, there are also [semantic
conflicts][semantic-conflicts]. These won't be caught by any tool. They can
only be caught by testing or manual review of the code.

To minimize the risk of both types of merge issues, I recommend:

1. Once a day, before continuing work on an existing feature branch, merge `master` into the branch††††
2. Merge `master` into any feature branch before you start a code review or acceptance test

### The Mayan Pyramid Of Doom

Pop quiz: what happens when a second merge is done in the following scenario?

![merge quiz]()

In some version control systems, the second merge [will result in a merge
conflict][svn-merge-conflict] because the first commit will be applied again
even though it was already applied. So what about git? Will the second merge
introduce a conflict?

Nope. Git is smart about merging branches with a shared history. No matter how
many branches you have and no matter how many times you merge any branch with
any other branch, git will never introduce a merge conflict by attempting to
re-apply a commit that already exists in the destinatino branch's history.†††††

Because git is so smart, it introduces a new way to shoot yourself in the foot.
I'm going to tell you a story about it. It all starts innocently enough:

![pyramid-start]()




Not to be confused with the [other pyramid of doom][callbacks-pyramid].

### Solution: Feature Flags

### Solution: Merge To Integration Branch

### Refactoring Leads To Merge Conflicts

### Solution: Continuous Integration Branch

Have you heard of "continuous integration"? 

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

If the readability of your commit history is something you're optimizing for,
that's cool too. Whether you merge or rebase is largely orthagonal to the
strategies presented in this post. In this post I give instructions that follow
the merge method because it's easier to explain. However, while reading along
in your head, feel free to:

- Replace:

  > merge from `master`/`integration-branch` into `feature-branch`

  with:

  > rebase `feature-branch` on to the latest `master`/`integration-branch`

- And replace:

  > merge pull request into `master`/`integration-branch`

  with:

  > squash `feature-branch` into a single commit and fast-forward merge `master`/`integration-branch` to it

  (but only if you're obsessed with linear history)

### Notes

† That isn't to say you shouldn't perform additional testing — whether automated or manual — before releasing new code in `master`. We run through our full automated test suite, in addition to doing manual smoke tests on the features that are being released, to try and ferret out any issues arising from running the new code in the production environment (as opposed to the dev environment).

†† In open source work — where contributors typically don't have push access to the canonical repo — creating a fork is necessary so contributors can push their changes somewhere. In team environments, typically everyone has push access to a single repo, so forking isn't necessary.

††† Before you object with, "always rebase instead of merge", please read [Michael's Guide To Merge vs Rebase Hygiene]().

†††† This could probably be automated with the right tool. I dream of a GitHub hook that runs on any commit to `master` (or any integration branch) and — using temporary scratch branches — attempts to merge the latest `master` commit into each feature branch. If the merge succeeds, the original feature branch is left untouched (to avoid filling the commit history with unimportant merge commits). If the merge fails, a comment is left on the pull request warning of the inevitable merge conflict. For bonus points, the hook could run the full automated test suite on each scratch branch and warn of any tests that will fail as a result of the merge.

††††† Not quite an exception, but still a gotcha to be aware of: if you merge branch A into B, revert the merge in B, make a change in A without merging B and without reverting the revert, then try to merge A into B again, you will get a merge conflict. The other "exception" is if you're rebasing in such a way to change the commit hashes of commits that have already been merged. But at least when you're rebasing without knowing what you're doing, it's understood that you're going to shoot yourself in the foot.

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
