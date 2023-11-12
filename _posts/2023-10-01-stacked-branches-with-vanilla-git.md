---
layout: post
title: "Stacked branches with vanilla Git"
date: 2023-10-01
tags: git
---

The first rule of stacked branches<sup><a href="/2023/10/01/stacked-branches-with-vanilla-git.html#note-1">1</a></sup> is don't use stacked branches:

1. Make small changes
2. Work closely with your teammates to get the changes merged quickly
3. Profit

*Alright, so you didn't take the advice*. Maybe you are making a big change that has to be worked as one big change, but you want to slice off pieces for reviewability. Maybe your teammates are slow to review your changes. So you put your first branch up for review, then you create a second branch off the first branch to keep working, then--if you're a glutton for punishment--you create a third branch off your second branch, and so on.

**Anyone who has set up stacked branches knows what a pain it can be to manage.** The initial setup is easy. The problem comes when there is a merge conflict between your stack and the `main` branch. Or what happens when you need to pull in a change that got merged to `main`.

If you haven't been keeping up with new Git features, your workflow probably involves a lot of `git checkout`s,<sup><a href="/2023/10/01/stacked-branches-with-vanilla-git.html#note-2">2</a></sup> lots of `git rebase` commands, maybe commit counting like `HEAD~123`, or `cherry-pick`s or who knows what other tedious work. Even after all that you probably missed something and now one of your PRs shows a bunch of duplicate commits.

It is 2023. There is a better way.

<!--more-->

---

## tl;dr

1. Never switch off your integration branch--it is a productivity killer
2. `git config --global --type=bool rebase.updateRefs true` ([docs][update-refs])
3. `git rebase --keep-base` ([docs][keep-base])

Don't worry if that doesn't make sense, it will when we are done.

## Walk-through

#### Pre-requisites

1. Update to Git 2.39.0 (December 2022) or newer.
    - The features we need are relatively recent.
2. Run: `git config --global --type=bool rebase.updateRefs true`
    - This will make rebasing a stack of branches way easier.

#### Example Setup

To keep things concrete, the following sections will be based off a hypothetical commit history:<sup><a href="#note-3">3</a></sup>

```sh
printf 'change M1\n\n' > foo && git add foo && git commit -m 'change M1'
printf 'change M2\n\n' >> foo && git commit -am 'change M2'
git switch -c feature-a
printf 'change A1\n\n' >> foo && git commit -am 'change A1'
printf 'change A2\n\n' >> foo && git commit -am 'change A2'
git switch -c feature-b
printf 'change B1\n\n' >> foo && git commit -am 'change B1'
git switch main
printf 'change M3\n\n' > bar && git add bar && git commit -m 'change M3'
git switch -
```

☝️ Don't stress the details, all you need to understand is this picture:

![commit history diagram](/assets/stacked-branches-with-vanilla-git/setup.svg){: .center }

There are some `main` branch commits. The feature branch `feature-a` is branched off of `main` at a point in time, containing a couple commits. Then there is another feature branch `feature-b` branched off of `feature-a`. Finally there is a newer `main` branch commit, representing other work that is happening outside of the `feature-a`/`feature-b` work.

## Scenario: rebase on main

If you haven't used `rebase --update-refs` before, this might blow your mind how easy it is to rebase *the whole stack* on `main`:

```sh
# Assuming you are still on feature-b
git fetch origin main:main                    # Pull latest main branch
git rebase main
git push --force-with-lease                   # Push feature-b
git push --force-with-lease origin feature-a  # Push feature-a
```

(We don't have to explicitly use `--update-refs` since we configured the option in the Pre-requisites step.)

The change looks like:

![commit history diagram](/assets/stacked-branches-with-vanilla-git/rebase.svg)

Now both `feature-a` and `feature-b` from the feature branch stack are based off of the latest `main` commit.

Notice how at no time do we switch off the latest working branch. Nor do we need to run `rebase` more than once. **The secret to working with stacked branches is to always be working in the final state**, then use surgical git commands to take care of details like pushing affected feature branches.

This pattern scales well even if you make the mistake of having branches-off-of-branches-off-of-branches to the Nth degree. The only work that scales is the number of `git push` commands, one for each branch you want to maintain. Even that work can be simplified down to one command with a git alias. (See `git fpstack` in [Appendix A](#appendix-a) for a suggested implementation.)

## Scenario: rebase to fixup earlier commits

To keep a clean, reviewable commit history, it is common to go back and edit earlier commits in the branch history. A fixup commit is when you make a new commit containing the fix and then use `git rebase` to meld the fix commit into the earlier commit.

Given the initial example, say we want to make the following change:

```
diff --git a/foo b/foo
index 2c060a5..e36a350 100644
--- a/foo
+++ b/foo
@@ -2,7 +2,7 @@ change M1

 change M2

-change A1
+change A1.5

 change A2
```

First, make the fixup commit:

```sh
sed -i 's/A1/A1.5/' foo
git commit -am 'fix A1'
```

Then perform an interactive rebase and push the changes:

```sh
git rebase -i --keep-base main # -i is short for --interactive
git push --force-with-lease                   # Push feature-b
git push --force-with-lease origin feature-a  # Push feature-a
```

When prompted for the rebase plan, change this:

```
pick 199deb5 change A1
pick 276c0a2 change A2
update-ref refs/heads/feature-a

pick 5915f8f change B1
pick a60ad9c fix A1
```

To become this:

```
pick 199deb5 change A1
fixup a60ad9c fix A1
pick 276c0a2 change A2
update-ref refs/heads/feature-a

pick 5915f8f change B1
```

Let the rebase finish and then run the push commands. You are now done.

![commit history diagram](/assets/stacked-branches-with-vanilla-git/fixup.svg){: .center }

Wait, isn't the before and after the exact same shape??

Precisely! It is intentional that the shape is the same. That is what the `--keep-base` option accomplishes. The only differences are to the commit SHAs, due to the file contents change.

For historical reasons, the rebase command performs two--conceptually different--operations:

1. Change the base commit of a branch (hence "rebase")
2. Rewrite the commit history of a branch (`rebase --interactive`)

As a matter of best practice, I recommend never performing both operations in the same command,<sup><a href="#note-4">4</a></sup> even though `git rebase` makes it easy (too easy) to do so.

The default behavior of `git rebase main` is to take the commits in your branch and base them off of whatever commit `main` points at, as if you had branched your branch off of the latest `main` commit. By contrast, the behavior of `git rebase --keep-base main` is to take the same commits (from the current commit back to the common ancestor with `main`) but keep them on whatever base they currently are.<sup><a href="#note-5">5</a></sup>

BTW if you know someone who still counts commits (`git rebase -i HEAD~123`) or looks up SHAs (`git rebase -i 1cec00l^`) you can tell them the good news: use `--keep-base`, since it replaces those older, hacky patterns.

## Scenario: rebase after "feature-a" is merged

In the happy path case, this is actually the same as the "rebase on main" scenario:

```sh
# Assuming you are still on feature-b
git fetch origin main:main                    # Pull latest main branch
git rebase main
git push --force-with-lease                   # Push feature-b
```

This works because the commit SHAs that exist in the `feature-a` branch are the same SHAs that now exist in the `main` branch. `git rebase` is smart enough to see that the commit SHAs are identical and automatically omits them from the comparison before rebasing on `main`. No annoying merge conflicts.

However, maybe GitHub is configured to Squash & Merge, which alters the commit SHAs. Maybe someone else force pushed `feature-a` prior to merge. Whatever the case, if you run into annoying merge conflicts you can back out of the first rebase with `git rebase --abort` then do this instead:

```sh
# Assuming you are still on feature-b
git fetch origin main:main                    # Pull latest main branch
git rebase feature-a --onto main
```

Where `feature-a` would be replaced with whatever branch name you were using that just got merged. With this command the rebase operation omits the commits in `feature-a`, which avoids weird merge conflicts where your own changes appear to be in conflict with themselves.

If you have branches-off-of-branches-off-of-branches (like if you had `feature-c` off of `feature-b`), you can repeat the steps in this section after each earlier branch is merged.

## Variation: integration branch first

So far we've been assuming that you are creating your reviewable branches one-at-a-time (`feature-a`, then branch to create `feature-b`, etc.). This is how most people stumble into stacked branches. It is often a good strategy.

Returning to the example from the beginning of the post, however, maybe you are making a big change that has to be worked as one big change, but you want to slice off pieces for reviewability. You could create a `feature-a` branch first, except the naming of that branch presupposes you know what order you want the changes to be reviewed and merged in, in the first place.

Instead start the work by creating a `feature-integration` branch, which will contain all the changes you are working on together. Later, when you better understand the specific changes you are making, you can re-order the commits with `git rebase -i` to group commits together that you want to slice off as their own reviewable and mergeable branches.

Imagine you run `git rebase -i --keep-base main` on your integration branch and you see the following plan:

```
pick 199deb5 change A1
pick 8b85087 change B1
pick 6e634af change A2
pick 8bef5cb fix A1
```

Just like in typical programming, the commits are in no particular order. As so frequently happens, you only wrap your head around the overall change you want to make after you've touched a bunch of different pieces.

From this mess let's say we now want to create a `feature-a` branch and a `feature-b` branch like before. First execute this re-ordered rebase plan:

```
pick 199deb5 change A1
fixup 8bef5cb fix A1
pick 6e634af change A2
pick 8b85087 change B1
```

Then we have to somehow create the branches to point at the associated commits. Remember the rule though: **never switch off your integration branch**. So how are we going to create these branches?

The commit SHAs will have changed since we re-ordered the commits, so we first need to get the new commit SHAs:

```sh
git log --oneline main..
```

It will look something like:

```
022ab4f (HEAD -> feature-integration) change B1
c17b2d9 change A2
5237e4c change A1
```

Then we can create and push the branch for `feature-a` with:

```sh
git branch -f feature-a c17b2d9
git push origin feature-a
```

And similarly for `feature-b`:

```sh
git branch -f feature-b 022ab4f # or HEAD
git push origin feature-b
```

The beauty of this method is that you are still on the `feature-integration` branch, ready to keep adding new work, while `feature-a` can go up for review.

## On collaborative stacked branches

This post was written with the assumption that the rebasing of the integration branch and ownership of the branch is all done from a single programmer's computer (potentially while pair programming). It is possible to collaborate on stacked branches between programmers working separately. However, it is a long time since I have had first-hand experience with the process, long before the exact workflow described in this post was possible. The only advice I have to offer is that `git pull --rebase` does the right thing in an uncanny number of circumstances. If everyone consistently works from the integration branch and always uses `git pull --rebase`, I suspect it will all work out. YMMV.

## Conclusion

Let's revisit the **tl;dr** from above and compare to what we've learned.

#### Never switch off your integration branch--it is a productivity killer

We have seen how you can perform every routine operation related to stacked branches without ever switching off the integration branch. Not only does this save time, it minimizes the chances of mistakes, like the kind that leaves one of your PRs with duplicate commits.

#### git config --global --type bool rebase.updateRefs true

We didn't explicitly talk about what this option does, but you may have a good idea already. If we did **not** enable `updateRefs=true` when rebasing--whether on `main` or an interactive rebase--the only branch that would get updated is the current branch (`feature-b` in our first example, or `feature-integration` in the later example). That would leave `feature-a` pointing at some commit in the pre-rebased code, which we don't want. While we could manually update what commit that the `feature-a` branch points at, it is better enable the option and let Git take care of this for us automatically.

#### git rebase --keep-base

We use the `--keep-base` option to concisely perform interactive rebases without accidentally pulling in changes from `main` in the same operation.

---

If you have been paying attention to Git news you may have seen [new][gitbutler] [tools][graphite] that make working with stacked branch workflows easier. I look forward to trying them out myself someday. 3rd party tools or not, however, I hope you see that vanilla Git is more than capable of handling basic stacked branch workflows.

<a name="appendix-a"></a>

## Appendix A: Suggested Git config

I am not here to tell anyone what specific git aliases to use, but I do suggest adopting some sort of productivity-boosting aliases. To give you an idea, this is what I use:

```sh
git config --global --replace-all --type=bool push.autoSetupRemote true
git config --global --type=bool rebase.autoStash true
git config --global --type=bool rebase.updateRefs true
git config --global core.autocrlf input
git config --global core.commentChar auto
git config --global init.defaultBranch main

git config --global alias.ca 'commit --amend --no-edit'
git config --global alias.ci 'commit --verbose'
git config --global alias.dc 'diff --cached'
git config --global alias.di diff
git config --global alias.fp 'push --force-with-lease'
git config --global alias.fpstack "\!git log --decorate=short --pretty='format:%D' origin/main.. | sed 's/, /\\n/g; s/HEAD -> //'  | grep -Ev '/|^$' | xargs git push --force-with-lease origin"
git config --global alias.l 'log --oneline'
git config --global alias.pullff 'pull --ff-only'
git config --global alias.pullrb 'pull --rebase'
git config --global alias.rb '!f() { if [ $# -eq 0 ]; then set -- origin/main; git fetch origin main; fi && git rebase "$@"; }; f'
git config --global alias.rc 'rebase --continue'
git config --global alias.ri '!f() { if [ $# -eq 0 ]; then set -- origin/main; fi; git rebase --interactive --keep-base "$@"; }; f'
git config --global alias.st 'status --short'
git config --global alias.sw '!f() { if [ $# -gt 0 ]; then git switch "$@"; else git branch --sort=-committerdate | fzf | xargs git switch; fi; }; f'
```

Perhaps in another post I can explain how to work all these commands into your workflow. For now, the relevant highlights are:

- `git rb`
    - If called with no arguments, rebases your branch/stack on the latest `main` branch
- `git ri`
    - If called with no arguments, opens the interactive rebase editor (without changing the base of the branch/stack)
- `git fpstack`
    - Force push all branches in your current stack

## Notes

1. <a name="note-1"></a> Some people prefer to talk about "stacked diffs" or "stacked pull requests" (PRs). Since this is a post about vanilla Git, I stick with "stacked branches" to refer to the concept. For all practical purposes you can substitute in the other terms and the advice is the same.
1. <a name="note-2"></a>  Stop using `git checkout` you dinosaur. For normal use cases, we have `git switch` now.
1. <a name="note-3"></a> If you want to play along at home--with the exact same commit SHAs--run the following commands before running the example git commands:

    ```
    rm -rf ~/Desktop/example-repo
    mkdir -p $_
    cd $_
    git init
    git config user.name Someone
    git config user.email someone@example.com
    export GIT_AUTHOR_DATE="2000-01-01T12:34:56"
    export GIT_COMMITTER_DATE="2000-01-01T12:34:56"
    ```

1. <a name="note-4"></a> You don't want to be dealing with surprise merge conflicts or changes from the base branch that you weren't expecting while you're in the middle of trying to re-write history. Re-writing history is already fraught with enough pitfalls. The small amount of time you might save by running both rebase operations in one command will be blown out of the water the first time you introduce a subtle bug due to a botched rebase.
1. <a name="note-5"></a> Why `--keep-base` doesn't imply `--interactive` is beyond me. For a branch based off of `main`, `git rebase --keep-base main` is a no-op.

[gitbutler]: https://blog.gitbutler.com/building-virtual-branches/
[graphite]: https://graphite.dev/
[keep-base]: https://git-scm.com/docs/git-rebase#Documentation/git-rebase.txt---keep-base
[update-refs]: https://git-scm.com/docs/git-rebase#Documentation/git-rebase.txt---update-refs
