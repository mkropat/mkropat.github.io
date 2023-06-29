---
layout: post
title: "Don’t change incrementally what can be done across-the-board"
date: 2023-06-28
tags: code maintenance
---

<p style="text-align: center">
    <img alt="elephant with lasers" src="/assets/dont-change-incrementally-what-can-be-done-across-the-board/elephant.webp" style="width: 60%" /><br>
    <em>How do you eat an elephant?</em>
</p>

In a living, evolving codebase inevitably changes will come up that you want to make everywhere. Maybe you discovered a better pattern that you want to apply throughout the codebase. Maybe entropy has caught up and some tedious change needs to be made everywhere.

In small codebases you just make the change when it comes up. Even in larger projects, sometimes there is no choice--the project won't build without biting the bullet--and so you end up making the change. More commonly though, you make the change in the files you touch and hope there is time to come back later to fix up other places.<sup><a href="#note-1">1</a></sup>

Such is the reality of programming for a business.

The thing is... what if making the across-the-board change didn't have to be a manual, time-consuming task? We're programmers after all! Automation is what we do.

<!--more-->

## How to automate codebase changes

Every programmer I've worked with knows how to Search And Replace In All Files. We handle renames like a boss. Experienced programmers also know that it is possible to leverage an [AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree) parser+serializer to script codebase changes in a *rigorous* fashion. How many of you are prepared to bang out that AST transformation code right now, though?<sup><a href="#note-2">2</a></sup> It is a lot of work. **What this post is about is the missing middle:** the tools and skillset that give you the flexibility to make changes more complicated than a rename, but without having to invest a bunch of effort upfront.

#### 1. Custom linter rules

Linters have really taken off. Pretty much every popular language has a comprehensive linter that is easy to get started with.

If you have never tried to write a custom linter rule, I encourage you to give it a go. It is a great way to dip your toe into AST programming, since there are tutorials that hand-hold you through the process and the framework does all the heavy lifting.

What you want to learn how to do is write a linter rule that can auto-correct offences. Once you have written a rule that detects the pattern that you want to change--and it can auto-correct the offense--you simply have to run the linter on your codebase and your across-the-board change will be done.<sup><a href="#note-3">3</a></sup>

Even if you don't get good at writing custom linter rules, merely spending the time to define a rigorous set of formatting linter rules really helps with the next tip.

#### 2. rg | sed -i

Why use perfectly good Search and Replace functionality in your editor when you can replicate the same outcome using 50-year-old UNIX technology:<sup><a href="#note-4">4</a></sup>

```sh
find . -name '*some_pattern*' -type f -exec sed -i 's/foo/bar/g' {} \;
```

Or a slightly different pattern I end up using more often for these changes:

```sh
rg --files-with-matches 'some.pattern' | while read -r f; do sed -i 's/foo/bar/g' "$f"; done
```

*Did I mention the escaping rules get insanely complicated?*

For all the jankiness of using ancient UNIX commands, you get something very powerful in return: extensibility.

You would be surprised at how many transformation problems that look impossible to achieve with a simple search-and-replace suddenly become easy when you chain multiple search-and-replace calls in succession. Sure, you can run Search And Replace In All Files repeatedly in your editor, but I've never found it practical when you have a half-dozen+ replaces you're doing. Whereas, with CLI commands you can prep all the search-and-replace commands in a scratch file, review and make changes, run them on a single file and iterate until you're satisfied, then run the commands on the whole codebase.<sup><a href="#note-5">5</a></sup>

The extensibility isn't limited to repeating multiple commands on the same file. A pattern I often use is to `rg -l` to find files in affected modules, then use `dirname` in the while loop to go back up and do the search-and-replace in a different but related file. When you have shell scripting and any CLI command at your disposal, there aren't many limits to what you can do.

Some quick tips:

* Trust your tests (and a pinch of engineer discernment) to let you know when you messed up the transformation.
* Don't spend time getting the formatting of the search-and-replace right. As long as the replacement is syntactically correct, the linter can fix most formatting problems.
* Learn regexs. They get crazy powerful once you start thinking about `--multiline` matches with lookaheads etc.. ChatGPT is a good crutch if you don't have time to practice.
* From a CS theory perspective, regular expressions are not capable of handling most programming languages [etc.](https://stackoverflow.com/a/1732454/27581). Don't worry about it. You are not trying to handle any theoretically-valid program supplied as user input. You are dealing with a specific codebase at a specific point in time. Regexs can handle 90%+ of what you need to do and the few edge cases can be handled manually.
* You can use a scripting language to do basically the same patterns. However I prefer to stick with the shell because it keeps my head in the game: keep it quick-and-dirty. Having a proper programming language makes it too easy to slip into "proper" coding practices that aren't helpful in this context.

#### 3. The gospel of Vim

Before you roll your eyes, I'm not here to sell anyone on Neovim as their daily driver. While I am a longtime Vim advocate, I have seen how productive other general editors have gotten in the last 10 years that I no longer consider Vim head-and-shoulders above the competition.

There is a killer feature, however, of learning Vim that I think is widely underappreciated--even by Vim users. When you learn Vim you are not only learning a text editor, you are learning possibly the most powerful language of text editing commands in existence. It is a crazy arcane, unintuitive language whose roots predate the existence of all text editors. [Seriously](https://en.wikipedia.org/wiki/Ed_(text_editor)). But it is powerful.<sup><a href="#note-6">6</a></sup>

When I try to explain to non-Vim users what can be done with macros, they don't get it.<sup><a href="#note-7">7</a></sup> "Oh, my editor has macro support too." No, I'm not talking about repeating a few simple commands, although I do that too. Vim macros let you do insanely complicated transformations. There is no theoretical limit. But in practice, the interface for defining macros becomes unmanageable beyond a certain length.<sup><a href="#note-8">8</a></sup> It is too easy to make a mistake while recording a long macro and have to start over again and again.

To break through that limitation, I've come up with a pattern that is basically legible macros:

```vim
" * Operate over a whole file: :call ConvertFile()
" * Or operate over a selection: :'<,'>call ConvertLine()
" * Supports the same :s// and normal commands you regularly use in Vim
" * So minimal Vim Script knowledge needed

function! ConvertFile()
  %global/^/call ConvertLine()
endfunction

function! ConvertLine()
  let line = getline(".")

  if line =~ "SOME_PATTERN"
    substitute/SOME_PATTERN/SOME_REPLACEMENT/
    substitute/ANOTHER_PATTERN//

    " You can even search ahead
    normal k$
    /SEARCH_PATTERN
    " Then run a command
    substitute/SOME_PATTERN/SOME_REPLACEMENT/
  elseif line =~ "SOME_OTHER_PATTERN"
    " Change {} braces to []'s
    normal $ma%r]`ar[
  endif
endfunction
```

Technically this is a VimL (Vimscript) function and invoked as such. However, the meat of it is all the normal commands you already know from using Vim. For example, ``normal $ma%r]`ar[`` is a common pattern from a macro, but made legible here where you could spot mistakes and easily make corrections.

If you are familiar with VimL, I have a second pattern that is even more powerful:

```vim
" Pattern 2:
"
" * Operate over a selected range: :'<,'>call ConvertRange()
" * Supports deleting lines that match a regex

function! ConvertRange() range
  let i = a:firstline
  while i <= a:lastline && i <= line('$')
    let line = getline(i)

    if line =~ "SOME_PATTERN_TO_DELETE"
      execute i "delete _"
      continue
    endif

    if line =~ "SOME_PATTERN_TO_MODIFY"
      let line = substitute(line, "SOME_PATTERN", "SOME_REPLACEMENT", "")
      let line = substitute(line, "ANOTHER_PATTERN", "", "")
      call setline(i, line)
    endif

    let i += 1
  endwhile
endfunction
```

You may have noticed that these VimL functions only run on a single file. If you are not a Vim power-user, you'll be forgiven for not knowing that Vim has many built-in capabilities for running commands across all relevant files. How to do this is beyond the scope of this post, but I can link you to a [project README](https://github.com/mkropat/vim-uniformity#usage) I wrote that gives starting pointers.

## Conclusion

Forgive me for keeping most of the guidance high-level. My goal isn't so much to walk you through making across-the-board changes in any language and for any type of change. My goal is to empower you to start to look for opportunities to quickly automate codebase changes that would have previously been considered a manual task--and an expensive manual task at that. Once you start developing the muscle, you'll stop looking at legacy code as an immovable burden and start seeing it as the malleable asset that it is.

## Notes

1. <a name="note-1"></a> The time never comes. This is how software archaeology is born, upon layers of old patterns and frameworks bedded down in your architecture.
1. <a name="note-2"></a> If you are lucky enough to be working in an established language that is amenable to static analysis, you don't have to write such tools because they probably already exist! They are typically sold as "refactoring" tools. This post is more about when you find yourself working with a language that is loosey-goosey.
1. <a name="note-3"></a> Don't worry about making the linter rule handle every last weird case. Most of the time you need to make an across-the-board change it is a one time thing. You only have to handle the cases that occur repeatedly in the codebase. You can handle the handful of exceptions manually, then you can delete the lint rule code having served its purpose.
1. <a name="note-4"></a> Translating the examples to PowerShell is left as an exercise to the reader.
1. <a name="note-5"></a> Much more repeatable too, when you inevitably discover two steps later that you made a mistake and you want to `git` reset back to the old state and re-run the transformations.
1. <a name="note-6"></a> [Turing complete powerful](https://buttondown.email/hillelwayne/archive/vim-is-turing-complete/), although really that is incidental to the kind of power I am referring to here, which is the power of expressiveness at mutating text.
1. <a name="note-7"></a> Except you Emacs users, you get the power of macros. Although there [aren't many of you left](https://www.youtube.com/watch?v=urcL86UpqZc).
1. <a name="note-8"></a> Kind of like how Search And Replace In All Files becomes unmanageable when you need to run too many different replacements in succession.
