---
layout: post
title: "Towards a better archive extractor interface"
date: 2022-12-20
tags: cli archive interface
---

I have waited years and years for someone to make a general purpose archive extracting tool the way I can picture it. The requirements are limited to:

1. Extracts all common archive formats (`.tar.bz2`, `.zip`, etc.)
    - This kind of goes without saying, but it doesn't pedantically "extract" a `.tar.bz2` into a `.tar` file (I'm looking at you 7-zip)
2. Needs no flags or subcommands or other configuration for the common use case
3. **Never creates more than 1 top-level file or directory per archive file**
4. **Doesn't add an extra layer of directory nesting when the archive only contains a single top-level directory**

<!--more-->

It is those last 2 requirements that makes me feel like some sort of UX normal-wit in a land full of half-wits. Nobody likes extracting an archive in their Downloads directory and have it barf all these generic README/Makefile/LICENSE project files everywhere. So what is the alternative today? Always get in the habit of extracting to a subdirectory, even though it adds unnecessary nesting 90% of the time? Or get in the habit of always inspecting the archive contents prior to extracting them, which is an easily automatable task?

I am sure some tool capable of this already exists in some form somewhere. But I can't find it, so I'm writing a blog post to popularize the idea. Feel free to [let me know](mailto:hello@kropat.email).

Here is my attempt at the platonic ideal of archive extractor interfaces:

```
❯ xt
Usage: xt ARCHIVE… [DEST]
```

No flags needed. It does what you think it should do (or at least what I think it should do). A two letter command name is allocated for such a common task.

One point of ambiguity is where to extract the archive: the directory that `ARCHIVE` is in? Or `$PWD`? I am pretty sure the latter is the unix-y interpretation, so that is what I went with.

For convenience, it supports multiple archive files in one go (what else would the interface use positional params for?). Trying it out in practice, I also found it convenient to be able to say, "extract this archive over there", hence the `DEST` parameter. There is some ambiguity with the meaning of the `DEST` parameter: does it mean ignore the 1-top-level file/directory rule and explicitly extract all the contents into the `DEST` directory? Or does it mean extract like `xt` normally does (at most 1 top-level file/directory per archive) but do it into the `DEST` directory instead of `$PWD`? I opted for the latter, but that may be a mistake.

An open question is what the behavior should be when piped. I didn't have any ideas, so I left the behavior undefined for now.

I have the sketch of an implementation over here:

[https://github.com/mkropat/xt](https://github.com/mkropat/xt)

I must stress *sketch of an idea*. Use it at your own risk. It isn't mean to be a real project (yet), but a test bed for trying the idea.
