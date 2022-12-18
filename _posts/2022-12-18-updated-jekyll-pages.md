---
layout: post
title: "Updated Jekyll Pages"
date: 2022-12-18
tags: github jekyll
---

**Heads up**: I intend to start posting more low-effot content here, more frequently.

This site was long ago a Github Pages site, but a while back I migrated it to over to [old-school web hosting][nfs]. The magic that makes it happen is a set of scripts I created, called [jekyll-pages][jekyll-pages]. Entropy took its toll in the intervening 4 years since I created it and it was due for a refresh.

<!--more-->

It is hard to get a complete sense of how good code you have written is, until you've left it alone for an extended period and come back to it later. On that score, I'm mostly pleased with the [jekyll-pages][jekyll-pages] code.

**The good**

* No security "vulnerabilities" I had to deal with, score one for shell scripting
    * Contrast this with coding ecosystems that tend to involve lots of dependencies (Ruby, JavaScript)
* Small projects are easy to understand
    * 135 lines of shell script; 6 Dockerfile lines
    * It is inevitable for projects that get a lot of use to accumulate code
    * But for anything else, keept the code *stupid*

**The bad**

* The files on the host outside of the container were all `root` owned
    * This is now fixed
    * It's easy to know how to use Docker to ship some code that will serve requests in production
    * I've always found the patterns around using Docker for any other use-case hard to discover
* Too many top-level scripts in the repo make it hard to intuit the entry-point
    * Sure, it's documented in the README, but if the files were better structured a new user wouldn't even have to read that to get started

**The ugly**

* Tarring secrets and passing them into the container via stdin is super awkward
    * I don't think I knew at the time that you can use `--volume`s to map single files into a container

It is a turn-off to me anytime I have to write code that is not of lasting value, especially when I'm not being paid to write said code. The churn in coding ecosystems du-jour, and coding ecosystems that produce projects that are highly sensitive to entropy, have diminished my appetite for building and publishing projects on the side. I have a number of ideas I've been exploring on this front—in languages that aren't terrible like shell scripting—but it's nice to see my shell scripting projects solve the problem too.

[jekyll-pages]: https://github.com/mkropat/jekyll-pages
[nfs]: https://www.nearlyfreespeech.net/
