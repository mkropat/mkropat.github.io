---
layout: post
title: "5 Custom Mappings To Improve Your Vim Navigation"
date: 2019-9-27
tags: vim
---

I recently started working on a couple projects that have really forced me to up my file navigation game in Vim. Part of it is knowing what plugins to use, but I think even more important is knowing how to work those plugins into your muscle memory.

After trying out various key mappings, I have landed on a basic set of custom key mappings I would recommend to anyone:

- <kbd>Control+Space</kbd> - open fzf
- <kbd>Control+^</kbd> - switch to `:A` alternate file
- <kbd>g</kbd><kbd>s</kbd> - search in all files
- <kbd>g</kbd><kbd>b</kbd> - open buffer list
- <kbd>g</kbd><kbd>o</kbd><kbd>f</kbd>/<kbd>g</kbd><kbd>o</kbd><kbd>t</kbd> - gtfo.vim

<!--more-->

### CTRL-Space - Open Fuzzy File Finder

There are [various][denite.vim] [fuzzy file][ctrlp.vim] [finder][fzy] plugins for Vim. I use [fzf.vim][fzf.vim].

![screenshot][ctrl-space-screenshot]

### gs - Search In All Files

### gb - Open Buffer List

### CTRL-^ - Switch To Alternate File

### gof/got - gtfo.vim

If you live exclusively inside of the terminal—whether that means using a terminal multiplexer or you go old-school with [<kbd>Control+Z</kbd>][job-control]—you might not get as much mileage out of this one.

On the other hand, if you use your desktop environment as a desktop environment from time-to-time, I highly recommend [gtfo.vim][gtfo.vim].

## Bonus Mappings

### g. - Open Vimrc

[gtfo.vim]: https://github.com/justinmk/vim-gtfo
[job-control]: https://web.mit.edu/gnu/doc/html/features_5.html
[ctrl-space-screenshot]: /assets/custom-mappings-to-improve-vim-navigation/ctrl-space.png
[denite.vim]: https://github.com/Shougo/denite.nvim
[ctrlp.vim]: https://github.com/ctrlpvim/ctrlp.vim
[fzy]:https://github.com/jhawthorn/fzy
[fzf.vim]: https://github.com/junegunn/fzf.vim
