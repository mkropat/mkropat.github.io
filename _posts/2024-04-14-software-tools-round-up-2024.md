---
layout: post
title: "Software Tools Round Up 2024"
date: 2024-04-14
tags: open-source software tools
---

**Note**: apologies to everyone who got an early copy of this post

Having had the need to do an OS reinstall or two lately, I've taken the opportunity to swap in a number of new tools and retire old tools. Unlike in my younger days when I would devote the time to survey every tool mentioned on Hacker News starting from time immemorial, the only tools that come into my awareness these days are the ones that people made a point to tell me about, or tools I found after getting fed up with a specific pain point and searched the web for a solution. All of which is to say, I'm not exactly Mr. Current Affairs.
![mad fish willy](/assets/software-tools-round-up-2024/mad-fish-willy.webp)

Still, maybe you will discover something of use.

<!--more-->

A quick note on what you will and won't find here:

- While I have the displeasure of using Linux, MacOS, Windows, Android *and* iOS on a weekly basis, my passion is for **open source** ecosystems, so this post is 99% about **Linux** and **Android**
- **Paid software** is good, actually; [ZIRP](https://en.wikipedia.org/wiki/Zero_interest-rate_policy)-driven enshittification really did suck the air out of the room<sup><a href="{{ page.url }}#note-1">1</a></sup> from what was once a diverse ecosystem of high-quality paid software
- Open Source + Paid is best; I am happy with Open Source *or* Paid; I avoid everything else
- I prefer to **self-host** where easy, but am open to “cloud” hosting when the trade-offs are sufficiently compelling

For fun, I've included country flags representing the location of the primary creator(s) of the project. You do what you want with the information. For me, I like to place things geographically (where such a connection exists), and to celebrate how this community is assembled from people around the world.

## Cloud/Self-Hosted

- [1Password](https://1password.com/) 🇨🇦 – [**Password Manager**] My password manager is one area where I intentionally do not self host. In the event that I find myself cut off from all my devices and backups, I still want to be able to bootstrap back into having access to all my stuff. To mitigate against service interruption, I keep a local backup.
- [Miniflux](https://miniflux.app/) 🇺🇸 – [**RSS Reader**] [rss](/links) > algorithmic timeline
- [Seafile](https://www.seafile.com/en/home/) 🇨🇳 – [**Cloud File Store**] Self-hosted; works for me.

## Shell

- [kitty](https://sw.kovidgoyal.net/kitty/) 🇮🇳 – [**Terminal Emulator**] GPU accelerated; feels smooth
- [Atuin](https://atuin.sh/) 🇬🇧 – [**Shell History Overhaul**] Sync and improved search.
- [bat](https://github.com/sharkdp/bat) 🇩🇪 – [**Util**] `alias cat=bat`
- [ncdu](https://dev.yorhel.nl/ncdu) 🇳🇱 – [**Util**] Disk usage explorer
- [pam-u2f](https://developers.yubico.com/pam-u2f/) 🇺🇸 – [**Auth Plugin**] Stop typing passwords into the terminal like it is the 1980s—we have hardware tokens now.
- [pure](https://github.com/sindresorhus/pure) 🇹🇭 – [**Zsh Prompt**] Minimalist prompt w/ async git status.
- [ripgrep](https://github.com/BurntSushi/ripgrep) 🇺🇸 – [**File Search**] First there was `ack`, then `ag`, now there is `rg`
- [zoxide](https://github.com/ajeetdsouza/zoxide) 🇮🇳 – [**Directory Switcher**] I cringe whenever I pair program with someone and they start typing out full directory names by hand.
- [xt](/2022/12/20/towards-a-better-archive-extractor-interface.html) 🇺🇸 – [**Archive Extractor**] Uhh… this was supposed to be throwaway code to test the idea, but over a year later and I still use this several times a week.

## Desktop

- [Espanso](https://espanso.org/) 🇮🇹 – [**Text Expander**] I mostly use it to bootstrap new remotes.
- [jumpapp](https://github.com/mkropat/jumpapp/) 🇺🇸 – [**Application Switcher**] Run-or-raise 4 life
- [Notesnook](https://notesnook.com/) 🇵🇰 – [**Note-taking App**] The best kind of app: open source + paid! My todo app, journal, project planner, math workbook, and more.

## Web

- [Firefox](https://www.mozilla.org/en-US/firefox/new/) 🇺🇸 – [**Web Browser**] Trusty old Firefox.<sup><a href="{{ page.url }}#note-2">2</a></sup> Google’s enshittified browser is a no-go for me as a daily driver. And as for the Chromium forks, I guess it comes down to I don't want to be forced to sign into my browser to be able to use it 🤷
- [Cookie AutoDelete](https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/) 🇨🇦 – [**Extension**] It is not perfect, but it makes the default web experience way less creepy.
- [uBlock Origin](https://ublockorigin.com/) 🇨🇦 – [**Ad Blocker**] Essential security software. Do your *non-tech-savvy* friends and family a favor and install it on their computers too.
- [Violentmonkey](https://violentmonkey.github.io/) – [**Extension**] Essential for power users. Not a fan of the name.

## Programming

- [asdf](https://asdf-vm.com/) 🇮🇳 🇺🇸 – [**Runtime Version Manager**] I hate the name but ultimately accepted that I prefer the consistency of having one tool instead of needing a copy of basically the same tool for every language (`nvm`, `rbenv`, etc.).

## Vim/Neovim

- [Neovide](https://neovide.dev/) 🇺🇸 🇩🇪 – [**Neovim UI**] Modern, smooth UI
- [dirvish.vim](https://github.com/justinmk/vim-dirvish) 🇩🇪 – [**Directory Explorer**] I ❤️ the philosophy of this plugin. Wish more Vim plugins were like this.
- [fzf.vim](https://github.com/junegunn/fzf.vim) 🇰🇷 – [**Fuzzy Finder**] My primary method to navigate projects.
- [gruvbox](https://github.com/morhetz/gruvbox) 🇷🇸 – [**Theme**] Everyone know about Gruvbox now, but that's because it is so damn good.
- [sensible.vim](https://github.com/tpope/vim-sensible) 🇺🇸 – [**Configuration Preset**] Universal defaults.

For the full list of whatever my current set of plugins is, check out [my dotfiles](https://github.com/mkropat/dotfiles/blob/main/plugins.vim).

## Utilities

- [Syncthing](https://syncthing.net/) 🇸🇪 – [**Network File Copier**] My go-to tool whenever I need to copy or share files between two devices, whether on the same network or across the globe.

## Android

- [F-Droid](https://f-droid.org/en/) 🇬🇧 – [**App Store**] I always install from F-Droid when possible, but will use the Play Store if it is the only option.
- [Kiwix](https://kiwix.org/en/) 🇨🇭 – [**Reference**] Put an offline copy of Wikipedia on your phone. Surprisingly useful. Fits comfortably on 256 GB phones. 128 GB is possible.
- [OsmAnd](https://osmand.net/) 🇺🇦 – [**Maps**] Offline maps
- [Podcast Addict](https://podcastaddict.com/app) 🇺🇸 – [**Podcast App**] The UI is a little busy for my tastes; it's what I happen to use currently.
- [Signal](https://signal.org/) 🇺🇸 – [**Messenger**] For as long as [Moxie](https://moxie.org/) is involved in the project, I trust it.
- [Voice](https://github.com/PaulWoitaschek/Voice) 🇩🇪 – [**Audiobook Player**] Basic, but gets the job done.

## Blog

- [Jekyll](https://jekyllrb.com/) 🇺🇸 – [**Blog Software**] The same software used by everyone who started their blog around the same time I did. Do I love it? No. Is it worth it to me to migrate away? Not yet.
- [jekyll-theme-antisocial](https://github.com/mkropat/jekyll-theme-antisocial) 🇺🇸 – [**Theme**] The theme you are currently looking at.
- [GoAccess](https://goaccess.io/) 🇺🇸 – [**Analytics**] 99% of static sites don't need Google Analytics.

## Change History

- **2024/4/14** – Initial version. I expect to make minor updates from time to time.

## Notes

1. <a name="note-1"></a> By some sort of collective utility yardstick, I wouldn't be surprised if we are better off as a result of the ZIRP shift in software. It's not all bad. As a power user though with a taste for well written software, there is a stark difference between the median app today vs. before.
1. <a name="note-2"></a> Firefox is mildly enshittified too, between the Pocket stuff and Cloudflare DNS and search/homepage sponsorship and whatever else I'm forgetting about. Mozilla the company has a weird abusive relationship with its community of power users and privacy lovers. For lack of great alternatives, we tend to overlook its faults.
