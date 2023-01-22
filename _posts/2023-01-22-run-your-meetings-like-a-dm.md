---
layout: post
title: "Run your meetings like a Dungeon Master"
date: 2023-01-22
tags: agile meeting
---

Specifically I am talking about meetings where the goal is solutioning. If you're planning out the logistics of how to get some well-defined work done, that is different. I'll save that for a "How to run meetings like a general" post. This post is about when you need to get people together to figure out a common direction on some ill-defined problem.

<!--more-->
---

The obvious thing to do--to younger me--to get a team aligned on a tricky problem would be would be to go off and draft the grand plan, as if I were Madison coming up with the [Virginia Plan][virginia-plan]. Then I present the plan to everyone, we all refine it, then go implement it. It really works that easily sometimes.<sup><a href="#note-1">1</a></sup>

Experience, however, has revealed the flaws in this approach to me amply. What happens when you bring the Virginia Plan but someone else at the meeting was thinking more along the lines of the [New Jersey Plan](new-jersey-plan). History shows you *can* work things out, but not without heartache and wasted effort. Much better to get people involved early. The second big flaw that becomes more relevant the farther along you are in your career is that your time and focus become in great demand. While it is fun to go off and create the grand plan, that time is probably at the expense of 5 other problems you could be making progress on.

Alternatively, you could go in the opposite direction: schedule a meeting and get everyone involved before any preparation has been done.<sup><a href="#note-2">2</a></sup> There is a certain appeal to the idea that you can discover what is already in everyone's heads before investing any time in solutioning. It is also a recipe for a **rudderless meeting**. But let us assume for a second that everyone can think on the fly and also stay focused on the problem statement--it is still too easy to start solutioning on some sub-problem that looms large in the minds of everyone at the meeting but is based on some ignorant assumption that even a cursory glance at the system in question would reveal is a complete non-issue.

Preparation is important. But what kind?

<img alt="dragon in a cave" src="../../../assets/run-your-meetings-like-a-dm/dragon.jpg" title="Created with DALL·E 2" />

### The role of a Dungeon Master

If you clicked on this post I assume you know what a Dungeon Master (DM) is, more generally known as as a Gamemaster. But in case not, here is what ChatGPT says:

> A Game Master (GM) is a person who acts as an organizer, facilitator, and rule-keeper for a tabletop role-playing game (RPG). The GM creates and controls the game's setting, non-player characters (NPCs), and the overall story, while the players take on the roles of characters within the game world. The GM also acts as a judge, interpreting and enforcing the game's rules and resolving disputes that may arise during play.

There are certain responsibilities integral to the DM role that have surprising applicability to running a meeting. Specifically:

1. It is their job to do the preparation work before a session
1. They set the stage for the players at the start of a session
1. They build out the world in response to the direction the players want to go in
1. When there is a lull, they prompt players in the direction of progressing the story
1. They have the rulebook at hand ready to reference, should a question arise

While the DM might have a good sense of where the players need to get to, the specifics of how they get there is the collective responsibility of the whole group.

### How to be the DM of a meeting

#### Preparation

In many ways, preparing to be the DM of a meeting is like setting out to come up with the grand plan of what to do, except instead of taking the time to draft the plan and present it you just skip those parts. What is left? Well… before you come up with a new plan you likely are going to survey what is already there:

- If someone has already made a requirements document, surely you'll start there
- If you're extending an existing codebase, you're going to look at the files you'll need to touch
- If there is existing data involved, you'll want to pull examples of database records / network requests / files so you know the exact shape of data you're working with
- If there are formal interfaces/contracts to meet, you'll have those within easy reach
- If the existing system has documentation, you'll skim through that
- If off-the-shelf solutions are a potential option, you'll search the web to come up with a list of options

Your job as the DM is to familiarize yourself with where all this information lives, not so you can answer every question off the top of your head, but so you can say, "one sec, I know exactly where to find that."<sup><a href="#note-3">3</a></sup>

In the process of gathering all this information a solution will likely be forming in your head already. That is great, it will come in handy if/when the group gets stuck. However, leave the plan where it is--in your head. Getting more detailed at this stage is a waste of time and adds inertia in potentially the wrong direction.

At this point, you are prepared as you need to be.

#### Meeting format

With the participants assembled, start by painting the setting. Describe the problem that the group needs to solve and why. Call out where the problem boundaries are, so effort is not expended on anything out-of-scope. Answer any questions people have about the problem statement. And with that all out of the way, open up the floor to anyone who wants to start talking about solutions.

This is where all the preparation you did really pays off. Some participants will jump right out of the gate with ideas, while others will try to participate and realize they are missing some key context. Often you can unlock that missing context for them simply by showing them the relevant function in the code, or a real example of the shape of the data involved. Later, you will be able to short-circuit some rabbit hole the group wants to go down, say chasing a potential edge case scenario, by bringing up the database and with a single query demonstrating that such an edge case could never happen. The group will quickly get a sense of the types of questions that you as the DM are readily prepared to answer, and they will take advantage of it. All of this doesn't guarantee per se that the discussion will be productive, but it removes entire classes of wasted discussion time.

I also recommend keeping a "map" of sorts along the way.<sup><a href="#note-4">4</a></sup> A figurative map, that is. Perhaps it is a shared document where you keep ongoing notes about solution approaches as they are discussed. Or perhaps it is a whiteboard, or anything you can draw boxes and arrows on. The specific format isn't important. What is important is to have some shared, visible artifact that forces all the participants to converge on the same vocabulary, the same structure, and hopefully/ultimately the same understanding in everyone's heads.

As the end of the meeting draws near, wrap up discussion with enough time to probe if a consensus solution has been arrived at. If the group isn't there yet, discuss what the next steps are.

### Advantages of the DM format

I have observed 3 key advantages to running meetings this way:

1. When participants aren't invested in pre-conceived plans, the group allows themselves to be surprised by solutions that are better than anything they would have come up with individually.
1. By actively participating in the creation of the plan, everyone involved tends to understand the plan far better than if they had sat through a mini-presentation about it.<sup><a href="#note-5">5</a></sup>
1. Less immediate but perhaps most impactful of all: by actively participating in the planning phase, everyone involved feels that much more invested in the success of the project.<sup><a href="#note-6">6</a></sup>

I encourage you to give it a go. If you try it and learn anything interesting (good or bad), <a class="u-email" href="mailto:{{ site.email }}">drop me a line</a> and I'll post them in a reader tips section.

### Notes

1. <a name="note-1"></a> Coming up with a grand plan—maybe solo maybe 2 or 3 people—really is the best approach when the problem is multi-headed and tweaking one part of the solution somehow affects every other part. There the concentration of context in as few individuals as possible is advantageous. Most routine business problems, however, are not so intractable. Choose your problem boundaries well, keep the scope small, and the advice in this post should work beautifully.
1. <a name="note-2"></a> If you schedule unprepared meetings regularly and your team has underutilized and/or easily distracted individuals who like to architect, a "no preparation" meeting will quickly become "everyone prepares individually in advance" meeting, which can have all the aforementioned heartache problems and then some.
1. <a name="note-3"></a> Probably in one of the open tabs in a dedicated browser window, if you are anything like me.
1. <a name="note-4"></a> Maintaining the map is a good task to delegate to another participant if you are worried about your attention bandwidth as DM.
1. <a name="note-5"></a> This saves implementation time. Also, I haven't observed this directly, but I hypothesize you get higher expected value when everyone is actively involved in the planning process, because more people are familiar with the assumptions involved with the plan, and so are equipped to call out the need to re-visit the plan when it is later learned that one of the assumptions isn't so.
1. <a name="note-6"></a> Kind of an [IKEA effect][ikea-effect].


[ikea-effect]: https://en.wikipedia.org/wiki/IKEA_effect
[new-jersey-plan]: https://www.thoughtco.com/new-jersey-plan-4178140
[virginia-plan]: https://www.thoughtco.com/the-virginia-plan-4177329
