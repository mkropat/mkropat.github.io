---
layout: post
title: "How to adjust the GUI font size in Vim or Neovim"
date: 2023-01-16
tags: vim font
---

So you want to increase or decrease the font size? Maybe as easily as pressing <kbd>Ctrl +</kbd> or <kbd>Ctrl -</kbd> like in every other GUI application out there? Keep reading.

<!--more-->

First things first, most Vim users still run `vim` (or `nvim`) from the command line. Nothing wrong with that. But if you are running Vim inside of a terminal emulator, know that the font isn't controlled by Vim--it is controlled by the terminal emulator, so look up the documentation for that. For example, I am using GNOME Terminal. In GNOME you can adjust the font size with <kbd>Ctrl Shift +</kbd> and <kbd>Ctrl -</kbd> and it just works™. In other terminal emulators you can often hold <kbd>Ctrl</kbd> and scroll the mouse wheel to adjust font size.

With that out of the way, this post is really about GUI Vim--whether that is gVim or one of the many Neovim frontends.

The easiest out-of-the-box way to adjust the font is to run:

```vim
set guifont=*
```

This will open a font picker. On my Linux install it looks like this:

<img alt="font picker screenshot" src="../../../assets/how-to-adjust-gui-font-size-vim-neovim/guifont-picker.png" style="margin: 0; width: 50%" />

Your font picker probably looks different, but it will have all the same basic options, including an input field for changing the font size.

After you select the new font, you can inspect the value with `set guifont?`:

```vim
:set guifont?
 guifont=IBM Plex Mono:h11
```

In my case, I am using a font named [IBM Plex Mono](https://www.ibm.com/plex/). And the font size is `h11`.

Say we want to share our screen during a presentation. We could bump up the font size to 18 by running:

```vim
:set guifont=IBM\ Plex\ Mono:h18
```

That font format should work on gVim for Mac or Windows, or Neovim on any OS, including Linux.

#### Linux GTK gVim

If you are running gVim on Linux, chances are you are using the GTK version of gVim and need to use a slightly different, simpler format:

```vim
:set guifont=IBM\ Plex\ Mono\ 18
```

## So what about keyboard shortcuts?

If we had `:IncreaseFont` and `:DecreaseFont` commands to adjust the font size, we could map keyboard shortcuts with:

```vim
nnoremap <C-+> :IncreaseFont<CR>
nnoremap <C--> :DecreaseFont<CR>
```

Unfortunately, __these font commands do not exist out-of-the-box__. There is no such functionality that ships with Vim.

That is why I created a plugin--[ezguifont.vim](https://github.com/mkropat/vim-ezguifont/)--that introduces these commands.

#### Installation

You can install `mkropat/vim-ezguifont` like [any other Vim plugin](https://vi.stackexchange.com/questions/613/how-do-i-install-a-plugin-in-vim-vi).  For example, with [vim-plug](https://github.com/junegunn/vim-plug) you would add:

```vim
Plug 'mkropat/vim-ezguifont'
```

#### Configuration

ezguifont.vim works best if you set an explicit font, instead of using the default (blank) font. Add the following to your `.vimrc`:

```vim
let g:ezguifont = 'IBM Plex Mono:h11'
```

Except you would replace the font with whatever `set guifont?` showed previously after you set it.

Next add the key mappings we hypothesized earlier:

```vim
nnoremap <C-+> :IncreaseFont<CR>
nnoremap <C-=> :IncreaseFont<CR>
nnoremap <C--> :DecreaseFont<CR>
```

(We map <kbd>Ctrl =</kbd> as well so you can omit holding the Shift key in <kbd>Ctrl Shift +</kbd>)

Restart Vim to have the settings take effect.

Now you should be able to <kbd>Ctrl +</kbd> and <kbd>Ctrl -</kbd> in Vim just like you do in any other GUI application! See the [ezguifont.vim](https://github.com/mkropat/vim-ezguifont/) README for full documentation.
