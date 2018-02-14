---
layout: post
title: "A Process Minimalist’s Guide To Retrospectives"
date: 2016-06-16
tags: agile retro
---

![retro photo][photo-1]{: .retro-side-photo }

Have you heard about Google’s Project Aristotle? It was a research project that
aimed to find out what combination of personality types, skill sets, and
backgrounds made up the most effective teams at Google. Are teams who hang out
outside of work more effective? Do you group introverts with other introverts?
Should teams share a preference for managerial style? Stuff like that.

(Bear with me—I promise this will tie back to retrospectives.)

So what did the researchers find out?

> “We looked at 180 teams from all over the company,” Dubey said. “We had lots
> of data, but there was nothing showing that a mix of specific personality
> types or skills or backgrounds made any difference. The ‘who’ part of the
> equation didn’t seem to matter.”
>
> —Charles Duhigg, [What Google Learned From Its Quest to Build the
Perfect Team][project-aristotle-nytimes]

And later in the article:

> Most confounding of all, two teams might have nearly identical makeups, with
> overlapping memberships, but radically different levels of effectiveness. “At
> Google, we’re good at finding patterns,” Dubey said.  “There weren’t strong
> patterns here.”

Did you catch that? Let that sink in for a minute.

Researchers at Google, who have access to more teams and more data than perhaps
at any other company in history, and who are experts at finding patterns
__could not find any strong patterns in what combination of individuals make up
an effective team.__ “The ‘who’ part of the equation didn’t seem to matter.”

However, the researchers __did find one attribute that effective teams shared: group
norms.__

In particular, they found two group norms that mattered most:

1. Conversational turn-taking—everyone talked in roughly the same proportion (not necessarily at any given moment, but, say, over the course of a week)
1. Psychological safety—no team member felt they would be judged for speaking up or blamed for taking risks

So… this is fascinating and all, but…

## What does this have to do with retrospectives?

Everything.

I’m not going to go into detail about [what a retrospective (retro)
is][retro-definition]. For purposes of a working definition, I think the [Agile
Manifesto][agile-manifesto] sums it up most succinctly:

> At regular intervals, the team reflects on how to become more effective,
> then tunes and adjusts its behavior accordingly.

If Project Aristotle shows that individual capability is eclipsed by overall
team effectiveness, and team effectiveness is enabled by group norms, then
overall effectiveness is largely determined by group norms. And I know of no
faster way to change group norms and to empower teams—not individuals on a
team, but teams themselves—than to hold effective retros.

![retro photo][photo-2]

*Jarret trying his hardest to make this retro look like a stock photo*
{: .caption }

What follows are my personal observations on what makes a good retro. Before I
joined Rackspace not-quite-2-years-ago, I had never participated in a retro.
Since then I’ve participated in a delightful variety of retro styles. I’ve been
in retros run by a full-time facilitator with Scrum certification (which were
awesome, thanks Bretny Khamphavong!), retros run by the team manager, and
retros run by individual team members. I’ve seen a spectrum of retros ranging
from highly structured retros with planned activities to completely informal
retros that consist of, “who wants to talk about what?”

Out of all them, I think the most effective retros can be boiled down to 4 key
elements:

## 1. Everyone Talks

I think this is the most easily overlooked of the 4 retro elements I’m going to
talk about.

Unless your team is a group of extroverts who are OK with interrupting each
other, your retros almost certainly represent only a subset of your team’s
members (and are only as smart as a subset of your team’s IQ) if you are not
actively soliciting the viewpoints of all members on the team.

Even if your team has no natural introverts, it’s just as easy to overlook the
viewpoints of new hires or junior members on the team. The “[weak
signals][weak-signals]” they send can be an incredibly valuable source of
action items to experiment with.

Job #1 of all the [retro formats and activities out there][retro-activities] is
to get everyone on the team talking.<sup>1</sup>

![retro photo][photo-3]

*It can help to have someone designated as a physical proxy for remote participants*
{: .caption }

When I am tasked with facilitating retros, I tend to stick with the simplest
activity I know works:

- Sticky notes and pens are handed out to all participants at the beginning of the retro
- Participants are asked to write down ~N things since the last retro that they felt a) went well, or b) could use improvement, or c) make you go hmmm
- Everyone takes a turn sharing the sticky notes they wrote down
- Any burgeoning discussions are asked to be tabled until everyone has had a chance to share what they wrote

__Note:__ while I like to be inclusive about who is welcome to attend a retro,
the “everyone talks” rule puts an upper bound on how many people can
productively participate in a retro.

It is difficult to take a team whose members do not practice good
conversational turn taking, and change the team’s behavior so that every
member—naturally, during the week—speaks in roughly the same proportion. What
is easily within our power though, is to carve out time at regular intervals to
explicitly solicit the viewpoint of every member on the team. And frankly, I
suspect that gets us most of the way there.

## 2. No-Blame Discussion

Once everyone has had a chance to talk, discussion can begin. Anything
team-related, especially ideas for improvement, is on-topic, but discussion
typically starts with topics identified during the initial retro activity.

On the teams I’ve been on, an informal approach has worked well. People start
the discussion by talking about what they think matters, the topic of
discussion changes naturally, and all the important topics tend to get
discussed.

If no one on your team wants to start the discussion, or if you have the
opposite problem—people want to discuss particular topics in such depth that
not all the important topics get discussed in the time allotted—then having
someone act as a discussion facilitator can help. If you did the sticky note
activity I described in the previous section, the facilitator can begin the
discussion by grouping sticky notes by common themes. The themes with a lot of
sticky notes are the topics to discuss first, and if there’s time left over
people can discuss anything else.

__The single most important rule to practice at retros is this: when reflecting
on the past, no blame can be assigned to team members for past actions.__ Any
decision or action (or inaction) is fair-game to question about how it might be
handled better in the future, but it must be done in full-faith<sup>2</sup>
that the person or people in question acted in what they thought were the best
interests of the team. This rule is so important that it has been called the
Retrospective Prime Directive:<sup>3</sup>

> Regardless of what we discover, we understand and truly believe that everyone
> did the best job they could, given what they knew at the time, their skills
> and abilities, the resources available, and the situation at hand
>
> —Norm Kerth, Project Retrospectives: A Handbook for Team Review

What this rule does is create a psychological safe space where team members can
talk openly about mistakes so the team can actually learn from them.

Even more generally than avoiding blame, if you want to create a [full sense of
psychological safety][psychological-safety], your retro needs to be a place
where people can question the status quo without being perceived as negative,
and people can suggest new ideas without feeling stupid or intrusive.

I have been fortunate to work exclusively on teams that provided me with a
sense of psychological safety, so I have no credible advice on how to get there
if your team lacks it. However, what I can talk about is a time I felt
vulnerable at a retro.

At the beginning of a critical new project I argued for the need to do a
“re-write” story that was supposed to take one developer maybe a week. It got
the go-ahead. Not quite three weeks later, myself and two other developers had
finished the story. We got it done, but it was hard work and it had jeopardized
the project overall. Needless to say, it was brought up at the next retro and
we talked about it a lot. Decisions were questioned. Missed opportunities were
identified. But not once did I feel personally called out. No one took my
mistake and doubted my earnestness to help or my competence in general. Going
further, we brainstormed ways that every member on the team (even the ones not
directly involved) could help get us out of such situations in the future.

I can only imagine how that would have went on a team that didn’t value
psychological safety. I probably would have stopped arguing for my ideas for a
while (which I like to think help more often than they hurt), not just at
retros but all the time. I also think I would have been soured on the idea of
retros, attending them with a sense of meeting resignation instead of
enthusiasm for improvement.

As a last thought on the importance of psychological safety, consider this quote from
[Google’s page about Project Aristotle][project-aristotle-google]:

> […] the safer team members feel with one another, the more likely they are to
> admit mistakes, to partner, and to take on new roles. And it affects pretty
> much every important dimension we look at for employees. Individuals on teams
> with higher psychological safety are less likely to leave Google, they’re
> more likely to harness the power of diverse ideas from their teammates, they
> bring in more revenue, and they’re rated as effective twice as often by
> executives.

So far we’ve seen how the “everyone talks” rule promotes conversational
turn-taking, and the “no-blame discussion” rule creates a sense of
psychological safety. These first two elements follow directly from Google’s
Project Aristotle research findings. The next two elements are all about taking
the advances the team has made during the retro meeting and figuring out how to
carry them over to the 98% of time that the team spends outside of retros.

## 3. Agree On Action Items

At retros without a facilitator, it’s easy to have really good discussion all
the way up to the end of the allotted time, and then everyone just leaves.
There’s value in doing only that, but over time it’s easy to lose faith that
talking at retros is making any difference. Even when it is making a
difference, perhaps in subtle ways, if actions taken are not made explicit and
brought up later, it’s still easy to lose faith.

Before wrapping up the retro, I recommend that the facilitator identify all the
items discussed that could potentially be turned into action items. It is up to
the team to decide which handful of the action items, if any, to agree to
tackle before the next retro.<sup>4</sup>

__Retro Tip:__ sometimes the team has seen clear mistakes and the resulting
action items are both pressing and obvious. That’s great, do them. Other times
everything is going fairly well and there’s nothing that needs to change. Use
those opportunities to experiment. Try something new you heard about that maybe
won’t be any better but shouldn’t hurt. If you do that enough times your team
will eventually be in a much better place.

## 4. Make Action Items Visible

After the “everyone talks” rule, I think the “make action items visible” rule
is the second most overlooked element of an effective retro.

![retro photo][photo-4]{: .retro-side-photo }

On a previous team, we used to dutifully take notes about everything discussed
in the retro: all the problems, all the proposed solutions, all the shoutouts,
and, yes, all the action items. The notes were recorded in the proper place—the
“retrospectives” section of the agile project management tool we use—and they
were shared with everyone on the team. Did anyone ever look at the agreed on
action items? Occasionally, usually the day before the next retro. Did they get
done? Sometimes, typically when someone wanted to do it anyway before we talked
about it during the retro.

There’s no quicker way to make sure something doesn’t get done than to assign
it to a group with no clear individual responsibility and to leave a reminder
for what needs to be done in a place that no one sees during their day-to-day
routine.

On our team we solved the problem by adding the retro action items to a special
section of the Kanban board that we work from everyday. It doesn’t really
matter where they get recorded—maybe it’s a whiteboard, maybe you write a Slack
bot that posts them every morning—the important thing is that every member of
the team can’t help but glance at the retro action items at least once a day.

Once you’ve made the action items visible, the only thing left to do is make a
point to talk at the next retro about what you learned from them.<sup>5</sup>

__Retro Tip:__ depending on how you record action items / make them visible,
the default state might be to “rollover” action items from one retro to the
next even when they weren’t discussed. Resist this. Declare action item
“bankruptcy” after every retro. If the team decides to commit to the same
action item again, that’s fine, but make it an explicit decision.

## Parting Advice

Anyone can propose a time for the next retro. If you think it’s been a while
since the last retro, make a point to schedule a new one. Too often I’ve seen
everyone wait for some designated person, maybe the manager, to schedule a
retro, and that person can get distracted because they’re busy. Besides, maybe
you’re the only person on the team who knows there’s important things to
discuss.

[Go read up on Project Aristotle.][project-aristotle-nytimes] If that doesn’t
convince you that retros matter, then I don’t know what will.

I guarantee you that your team will improve over time if you regularly meet for
retros that have these 4 elements:

1. Everyone talks
1. No-blame discussion
1. Agree on action items
1. Make action items visible

In my view, those are the minimum 4 elements of an effective retro.

__In reality, they’re a starting point.__ Try them out. Figure out as a team
what works and what doesn’t. If your team meets regularly to reflect on how
things are going and has earnest discussions about how to improve the team as a
whole, your team will get better over time. Maybe even by a lot, if Project
Aristotle applies to your team too.

Feedback? Thoughts? Your experiences? You can share them on [this Reddit
thread][reddit-thread].

## Footnotes

1. That’s just like my opinion, man. I recognize that retro activities are not limited to getting people to talk—they’re useful for getting people out of routine modes of thinking, for helping people understand where other team members are coming from, and a bunch of other purposes.
1. Even if you truly believe that a team member did not act in the best interest of the team, and it undoubtedly happens (sometimes for good reasons even), the retro is not the time to discuss it. There are other venues to discuss such things, and when you bring it up at the retro you undermine any psychological safety that team members feel to openly discuss how things could be done better and even to try new things outside of the retro.
1. I don’t know why people first started calling it the “Prime Directive,” but I hope it fares better than in Star Trek where every episode that references the Prime Directive finds some reason to break it later in the episode.
1. The important thing is that it’s the team’s decision about what to tackle and the team’s responsibility whether it even gets done. I’ve never seen it done, thankfully, but if a manager or some outside force is dictating retro action items and holding the team accountable for them, then the entire point has been missed. The point is to develop a team’s sense of self-efficacy and to prompt action that the team has already agreed is worth doing.
1. Again, the idea is to reflect on changes the team has accomplished and to maybe be aware of what hasn’t been done yet. If action items are routinely not accomplished, then that’s just another thing you can talk about at retros. Maybe the team is taking on too many items, or maybe they’re committing to things out of their control, or maybe the action items aren’t visible enough—that’s how the team I was on arrived at putting the action items on our Kanban board.

[agile-manifesto]: http://agilemanifesto.org/principles.html
[photo-1]: /assets/process-minimalist-guide-to-retros/retro-finding-themes.jpg
[photo-2]: /assets/process-minimalist-guide-to-retros/retro-not-stock-photo.jpg
[photo-3]: /assets/process-minimalist-guide-to-retros/retro-remote-participant.jpg
[photo-4]: /assets/process-minimalist-guide-to-retros/retro-action-items.jpg
[project-aristotle-nytimes]: https://www.nytimes.com/2016/02/28/magazine/what-google-learned-from-its-quest-to-build-the-perfect-team.html
[project-aristotle-google]: https://rework.withgoogle.com/blog/five-keys-to-a-successful-google-team/
[psychological-safety]: https://www.youtube.com/watch?v=LhoLuui9gX8
[reddit-thread]: https://www.reddit.com/r/programming/comments/4ohfel/a_process_minimalists_guide_to_retrospectives/
[retro-definition]: https://www.benlinders.com/2013/whats-an-agile-retrospective-and-why-would-you-do-it/
[weak-signals]: https://danluu.com/wat/

[retro-activities]: http://retrospectivewiki.org/index.php?title=Retrospective_Plans
