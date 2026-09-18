# AGENTS.md — Writing Style Guide for This Blog

This guide tells you how to write a blog post that matches the established voice of this site. The analysis comes from all posts from 2015 to 2024. Follow these instructions when you draft or edit posts in `_posts/`.

## Voice and Persona

- Write in the first person. The author is a practicing software engineer who reports from experience, not from authority.
- Address the reader directly as "you". Use "we" and "let's" when you walk the reader through steps or code.
- Be opinionated. State positions plainly and bold the thesis sentence. Examples: "**Pick whichever framework makes sense for your project and don't worry about it.**", "**Don't use the word "nit" in your code reviews.**"
- Undercut authority with self-deprecating disclaimers. Examples: "I have no qualifications to write on the subject", "I am an odd duck when it comes to taste", "I'm probably among the least-qualified people to talk on the subject."
- Be honest about uncertainty. Mark unverified claims with "**Untested**", "YMMV", "take all the above with a grain of salt", or a footnote. Never fake confidence.
- Acknowledge the strongest counterargument before you argue against it. Often concede part of it. Example: the HTTP status code post opens its conclusion with "I'm not completely sure they do matter."
- Invite correction and feedback. End posts or sections with a mailto link ("drop me a line") or a link to a discussion thread, and offer to add a reader-tips section.

## Tone and Humor

- Keep the register conversational but technically precise. Casual interjections are in-bounds: "Err, nope.", "Whew, the hard part is over.", "Alas", "btw", "WTF".
- Use rhetorical questions to drive transitions: "What gives?", "How would that even work??", "So where is the problem?"
- Deploy humor as seasoning, not the meal. Approved forms:
  - Pop-culture and history references (Star Trek's Prime Directive, MCU tie-ins, Sun Tzu, the Virginia Plan, `sfalken@wopr.example`).
  - Memes and images with a joke in the image title-text (little bobby tables, geordiposting).
  - Mock-serious framing: "You're welcome, internet. That day is now."
  - The occasional emoji (🚢, 😃, 🤷) — at most a few per post.
- Placeholder names lean silly: `foo`/`bar`, `herp`/`derp`, `DerpComponent`.

## Structure

- Open with a hook before any background: a concrete problem scenario ("You shipped a project at work…"), a provocative claim ("The first rule of stacked branches is don't use stacked branches"), or a reproducible bug in famous software.
- Place the Jekyll excerpt marker `<!--more-->` after the first 1–4 paragraphs. The text above it must stand alone as a teaser.
- For long how-to posts, add a `### tl;dr` section near the top with a numbered list of the whole procedure. Follow it with a reassurance: "Don't worry if that doesn't make sense, it will by the end of this post."
- Break the body into `##` or `###` sections. Numbered section titles are common for lists of lessons ("1. WebSockets Don't Honor the Same-Origin Policy").
- Anticipate objections with sections framed as reader quotes: `### "I need bullet points"`.
- Push tangents into footnotes. Use superscript anchor links (`<sup><a href="#note-1">1</a></sup>`) that point to a `### Notes` section at the bottom. Footnotes carry real content: caveats, war stories, jokes.
- Close with one of: a practical summary that revisits the tl;dr, an encouragement to try the idea, or a deliberate anticlimax ("What you choose to do is up to you."). Do not write a formal conclusion that restates everything.
- Optional recurring end sections, in this order when present: `## Summary`/`## Conclusion`, `## See Also` or `## Some Other Good Reads`, `### Notes`, credits.
- Mark post-publication corrections inline with a dated note: "**Update 2019/11/5**: …". Do not silently rewrite.

## Paragraphs and Sentences

- Keep paragraphs short: 1–4 sentences. A one-sentence paragraph is a valid emphasis device. So is a one-word paragraph ("Everything.", "Maybe.", "*Easy.*").
- Bold the sentences that carry the post's key claims, roughly one per major section.
- Use em-dashes (typed as `--` or `—`) and ellipses ("…") for conversational rhythm.
- Prefer concrete numbers and specifics over vague quantities: "135 lines of shell script; 6 Dockerfile lines", not "a small script".
- Define jargon on first use with a short parenthetical or a link, then use it freely.

## Evidence and Examples

- Ground every claim in something checkable: a code sample, a quote from an RFC or documentation (as a blockquote with attribution), a chart, a link, or a first-person war story.
- Show code early and often. Keep samples minimal but runnable-looking. Annotate with short comments like `// kaboom` or `// did I mention that desiredQuantity could be null?`.
- When you show a wrong approach, show it first, let the reader feel the problem, then reveal the better way. The "problem → naive fix → why that fails → real fix" arc is the house pattern.
- Link generously. Use Markdown reference-style links (`[text][ref]`) with the definitions collected at the bottom of the file, roughly alphabetized.
- Cross-link related posts on this blog with `{% post_url … %}` or relative URLs.
- Use `<kbd>` tags for key presses and `__bold__` or `**bold**` for UI element names in instructions.
- Include images with jokes or attribution in the title-text. Credit image licenses (e.g., "Copyright 2008 Roman Bonnefoy - CC BY-SA 3.0").

## House Vocabulary and Tics

- "So you want to…" / "So you need…" as a section or post opener.
- "Here is the thing:" / "Here is the cool part:" before a key insight.
- "left as an exercise to the reader" for out-of-scope work.
- "It is 2023. There is a better way." — appeals to the current year for overdue practices.
- Lazy-programmer virtue framing: "In programming, laziness is a virtue."
- Rhetorical concession openers: "Make no mistake…", "Don't get me wrong…", "I am not here to dissuade you…"

## Front Matter and File Conventions

- Name post files `YYYY-MM-DD-kebab-case-slug.md` in `_posts/`.
- Use this front matter shape:

  ```yaml
  ---
  layout: post
  title: "Title Here"
  date: YYYY-MM-DD
  tags: lowercase space separated
  ---
  ```

- Title style: posts before ~2020 use Title Case; posts from 2022 on use sentence case ("Add more context to your PRs"). Prefer sentence case for new posts.
- Titles promise a concrete payoff and are often slightly cheeky: "CSS Specificity Explained In 300 Words", "How To Not Suck With PowerPoint", "Stacked branches with vanilla Git".

## What to Avoid

- Do not write corporate or SEO-flavored prose. No "In today's fast-paced world", no "delve", no listicle padding.
- Do not present opinion as settled fact. Flag it as opinion, then argue it hard.
- Do not write long unbroken paragraphs or formal academic transitions ("Furthermore", "Moreover").
- Do not over-explain what a linked resource already covers. Link it and move on: "Go read the spec."
- Do not strip the personality when you edit. The asides, footnotes, and jokes are load-bearing.
