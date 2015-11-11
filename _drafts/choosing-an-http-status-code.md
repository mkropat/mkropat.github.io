---
layout: post
title: "Choosing an HTTP Status Code — Stop Making It Hard"
date: 2015-11-05
tags: http rest
---

What could be simpler than returning HTTP status codes?  Did the page render?
Great, return `200`.  Does the page not exist?  That's a `404`.  Do I want to
redirect the user to another page?  `302`, or maybe `301`.

Life is bliss, well... until someone tells you you're not doing this REST
thing.  Next thing you know, you can't sleep at night because you need to know
if your new resource returns the RFC-compliant, Roy Fielding approved status
code.  Is it just a `200` here?  Or should it really be a `204 No Content`?
No, definitely a `202 Accepted`... or is that a `201 Created`?

What complicates matters is that the official HTTP/1.1 guidelines — the RFC —
[was originally written in 1997][rfc2068].†  That's the year you went surfing
the cyber-tubes in Netscape Navigator on your 33.6kbps modem.††  It's a little
like trying to apply Sun Tzu's *Art of War* to modern business strategy.
Timeless advice, to be sure, but I haven't yet figured out how The Five Ways to
Attack With Fire are going to help me do market validation.

For example, in a JSON-enabled REST API, which code gets returned to say that
the user needs to OAuth?  There's a `401 Unauthorized`, but that only talks
about HTTP auth, which in case you don't remember, tells the user's browser to
open this lovely login form:

![basic auth screenshot]()

*Even older than Web 2.0*

If only there was some kind of visual decision tree that would let you quickly
identify the few status codes that were relevant to your situation so you could
ignore all the chaff.

You're welcome, internet.  That day is now.

Before we jump into the meat of the diagrams, you first need to know where to
start:

![http status codes]()

It may seem ridiculously obvious, but I've see too many people get lost in the
weeds wondering whether, "is this more of a `501 Not Implemented` or a `410
Gone`?"  Stop.  If you ever find yourself deliberating between specific codes
in entirely different response classes, you're doing it wrong.  Go back and
look at the flowchart.

Having identified the high-level response class that fits your sitatuion, you now know which flowchart to consult.

A few notes before you dive in:

- You don't have to take my word for it — go read [RFC 7231][rfc7231]
- The audience I have in mind is someone making a website or RESTish API
- Response codes specific to implementing a web server are glossed over (and
  omitted entirely for proxy servers)
- I've grouped responses into three rough categories:
  - Standard — It's hard to imagine making a site or API without these
  - Useful — Not strictly necessary, but returning these where appropriate will
    help anyone who's familiar with HTTP to consume your site or API and
    troubleshoot any issues that may arise
  - Irrelevant — Chances are, you can safely ignore these and return a more general code instead

Last but not least, I have no qualifications to write on the subject, other
than that I'm a guy who's read some RFCs and works at an office, Racksburg,
where we try every day to make useful APIs.  If you think I'm wrong or I've
slighted your favorite status code, it's probably because I'm an idiot and you
should go here and let me know exactly how.

### 2XX/3XX

### 4XX Bad request

### 5XX Server error

### Coda: On Why Status Codes Matter

I'm not actually sure they do.

There's a lot of smart people at Facebook and [they built an API][graph-api]
that only returns `200`.

### Notes

† Pay no mind to RFC 2616 (or even worse, 2068).  The RFC you're looking for is
[7231][rfc7231].

†† Unless, of course, you were a LPB on your college T3 connection.  Yes, I
actually lived through these days in case you were wondering from my
anachronistic use of "cybertubes."

Flowchart changes:


307, 308

[rfc2068]: https://tools.ietf.org/html/rfc2068
[rfc7231]: https://tools.ietf.org/html/rfc7231
[graph-api]: https://developers.facebook.com/docs/graph-api

