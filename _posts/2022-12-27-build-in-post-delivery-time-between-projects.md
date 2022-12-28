---
layout: post
title: "Solve the tech debt problem with post-delivery time"
date: 2022-12-27
tags: project-management software-engineering
---

You shipped a project at work. Time to focus on the next project *exclusively*, right?

If you've worked on many projects, you know that what I just said is unrealistic. At the very least, there is likely more planning that needs to be done and key decisions made before work can start in earnest on the next project. Beyond that there are likely post-delivery issues that will come up and need addressing. Oh, and maybe there is some work we can do to leave things in a better state?

The mindset of considering the old project "done" at delivery is overly simplistic, yet that is what I observe happen time and time again. At least that is what happens when no one makes a point to make post-delivery project work *explicit*.

<!--more-->

---

A key factor in keeping a team productive and engaged is setting a realistic pace towards delivering business value. Too aggressive, and people burn out—either from feeling the need to work excessive hours, or from cutting corners to speed towards building a system that no one feels good working on. Too lax, and people are also driven away, because the vacuum ultimately gets filled with meaningless work.

There are many levers one can pull to keep on a realistic pace. The smartest is to keep project size small. Cut scope and accept that with small, iterative projects there will be plenty of opportunity to do the work later if it is important enough.

After your team is committed to a set of deliverables by a set time frame, however, the biggest lever you can pull is identifying work that can be **deferred** to after delivery. Some of this work will be *fast follow* work—work that has to be done, but not necessarily before delivery. And some of it will be newly identified **non-essential** work, which often requires the clarity of an impending deadline to identify.

For example, let's say you launch a new feature that lets users sign up now and get billed later. The deliverable is probably defined as turning on the new sign up feature. If the first users won't get billed until 30 days later, any work necessary to support billing is a candidate for handling as *fast follow* work.

If you don't build in time on the roadmap for newly-identified post-delivery work, your team risks suboptimal outcomes at either end:

1. You defer work to be able to deliver on time, and then your attention is split excessively between starting the next project and finishing non-cut-able features from the old project
2. You don't defer work because your org has no concept of post-delivery work, so you defer the deadline instead, losing out on early feedback and suffering opportunity costs

Pretty straightforward.

Here is the cool part: **building in post-delivery time between projects solves the tech debt problem**. Alright, maybe it doesn't solve it once and for all. What it does is dissolve all contention around tech debt by taking the people in the org who are best equipped to make smart tech debt trade-offs—engineers—and empowering them with the context and clarity necessary to make those trade-offs.

> Give me six hours to chop down a tree and I will spend the first four sharpening the axe.

— [Apocryphal quote](https://quoteinvestigator.com/2014/03/29/sharp-axe/)

Axe sharpening is generally sound advice—work smarter, not harder. But the quote suggests another meaning, cautioning against procrastinating important work with easy work that looks productive and yet quickly becomes the opposite.

Effective programming is all about embracing "work smarter, not harder." A measured amount of axe sharpening is good. But software engineers as a type tend to axe sharpen to a fault. When setting out to build or modify a system, every quick-and-dirty solution (whether existing or to-be-built) looks like a mountain of tech debt. Engineers—myself included—are terrible about making balanced assessments prior to delivering the project. Not always, sometimes it is obvious that tackling a particular tech debt item up front will save a ton of time on project delivery. But more typically a tech debt item that seems so important today often matters very little to anyone a month later.

We can exploit this bit of psychology for our purposes: aggressively defer any tech debt work that can be deferred to after delivery of the project.<sup><a href="#note1">1</a></sup>

There is a myth in the heads of many in the software industry that engineers as a rule would work non-stop on tech debt work if you gave them the time to do so. My firsthand experience is anything but:

- **Week 1**: This is amazing, we are finally given the chance to clean up all this code.
- **Week 2**: This is great. Things are getting cleaner. I wonder what business projects we'll work on next.
- **Week 3**: I'm not sure if any of the tech debt work left is actually worth it. I hope the next project comes soon.
- **Week 4**: Please, oh please, let this unstructured work period end.

A couple weeks on the roadmap for post-delivery work is often ample. Rarely do engineers have the appetite for doing more consecutive tech debt work than that, especially when planning has begun on the next project—it is hard to resist not working on the next shiny new thing. In the post-delivery tech debt world, no one needs to be the bad guy and say "the business can't afford to do that right now." Between having all the possible tech debt work stacked against each other, and having the carrot of the next project, engineers will naturally prioritize the actually important tech debt work and accept that the rest isn't really worth doing right now.<sup><a href="#note2">2</a></sup>

Of course, none of this is possible if there isn't time built-in to the roadmap for post-delivery work. It also doesn't work if "defer" becomes a euphemism for "cut."<sup><a href="#note3">3</a></sup>

So carve out post-delivery time when planning projects. Initially there will be little-to-no specific work planned for that time. Resist the temptation to confuse a lack of specific work items to be done for no work to be done. Valuable post-delivery work always comes up, and if it doesn't fill the time allotted, great, you can start on the next project early. It takes discipline and a little forethought, but that seems a small price to pay for avoiding one of the thorniest problems in software engineering.

### Notes

1. <a name="note1"></a> This also improves the tech debt situation from a surprising angle: a common form of tech debt is having extra code that didn't really need to be written. Rarely do you truly understand all the requirements prior to delivering a project. Yet if you try to "avoid tech debt" by building abstractions ahead of time, it is easy to build the wrong abstraction, making the situation worse than if you had done no tech debt work at all. The best of all worlds is often to deliver the quick-and-dirty solution, then refactor post-delivery.
1. <a name="note2"></a> The current team, at least, will be accepting of the state of the code if they ever have to come back and work in it, since they are aware of the trade-offs. Other teams may see the state of the code as a mountain of tech debt, but they too can address problems with their post-delivery work, should they work in that area of the code. Having strong team code ownership can help too.
1. <a name="note3"></a> It is usually fine if like half the work that gets deferred—whether product work or tech debt work—never gets worked on ultimately. That is the magic of post-delivery clarity. But when almost none of the deferred work ever gets worked on—and everyone knows it—then talking about "deferring" work is useless.
