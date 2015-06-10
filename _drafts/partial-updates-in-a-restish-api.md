---
layout: post
title: "Partial Updates In A RESTish API"
date: 2015-08-17
tags: rest api
---

Like disucssions about politics, religion, and fitness/diet, discussing
RESTful HTTP semantics is an easy way to lose friends.  Maybe you won't
hate me as much if I first tell you where I'm coming from:

1. I don't like to violate widely-adopted RFCs unless I have a good reason
1. I have yet to design a proper RESTful API and I don't see myself doing so†

- https://stackoverflow.com/questions/630453/put-vs-post-in-rest
https://stackoverflow.com/questions/2364110/whats-the-justification-behind-disallowing-partial-put
- https://stackoverflow.com/questions/630453/put-vs-post-in-rest
- http://williamdurand.fr/2014/02/14/please-do-not-patch-like-an-idiot/
- https://www.mnot.net/blog/2012/09/05/patch
- http://www.thoughtworks.com/insights/blog/rest-api-design-resource-modeling

† It's not that I don't see value in REST, just that the problems that REST
solves don't occur frequently in my problem space.  Specifically, I'm
either writing both the server and client, or anyone who implements a
client expects an API contract that might as well be RPC.
