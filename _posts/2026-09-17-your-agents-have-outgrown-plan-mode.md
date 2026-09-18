---
layout: post
title: "Your agents have outgrown plan mode"
date: 2026-09-17
tags: ai agents workflow
---

When factories first got electricity, they did the obvious thing: unbolted the steam engine and bolted a giant electric motor in its place. Same central drive shaft, same belts, same layout. Productivity barely moved for thirty years.

Then someone realized electricity didn't want to be one big motor--it wanted to be a small motor on every machine. Factories got rebuilt around that idea, and output exploded.

Plan mode is the giant motor bolted where the steam engine used to be.

<!--more-->

## First, definitions

By plan mode I do mean, literally, the [Plan mode in Claude Code][plan-mode] and its equivalents in other harnesses. But I also mean something looser: **any process that produces artifacts spelling out how to build something.** The [superpowers][] skill is a popular example of the latter.

If you have a doc that lists what files to add, or what classes and functions to write, you have a plan.

If you have a doc that specifies which lines in which files need to change, you have a plan.

If you have a list of tasks for the agent to burn down, you have a plan.

## In defense of plan mode

Make no mistake, plan mode is appealing for good reason. Reviewing a plan takes minutes; reviewing the diff of a finished implementation takes… longer. Misunderstandings get caught before they turn into code. You stay oriented on what the agent is doing without reading every line it writes.

And sometimes it is exactly the right choice. When you are making a surgical change in an established system, there is often only one, fairly well understood way to do it. Write it down, have the agent execute it, done. I am not here to dissuade you from planning those.

Plan mode was a perfectly rational way to work with the models of two years ago. The models have grown since then. Most workflows haven't.

## The ceiling

Despite all its advantages, plan mode is ultimately limiting. **A plan is only ever as good as the model of the system that you and the agent can hold in your heads before the work starts.**

<p style="text-align: center">
    <img alt="Capt. Joseph McConnell in the cockpit of his F-86 Sabre" title="Sixteen victory stars, zero planning documents" src="/assets/your-agents-have-outgrown-plan-mode/f-86-pilot-cockpit.webp" style="width: 80%" /><br>
    <em>Capt. Joseph McConnell in the cockpit of his F-86 Sabre. USAF photo, public domain.</em>
</p>

You didn't think you'd get through this post without a John Boyd reference, did ya?

## A puzzle from MiG Alley

[John Boyd][boyd] flew F-86s in Korea, taught air-to-air combat at the Fighter Weapons School,<sup><a href="#note-1">1</a></sup> and spent the rest of his career as a military strategist being productively insufferable to his superiors. The puzzle that started it all came out of Korea: the F-86 Sabre versus the MiG-15.

| | F-86 Sabre | MiG-15 |
|---|---|---|
| | <img alt="F-86E Sabre at the Cavanaugh Flight Museum" src="/assets/your-agents-have-outgrown-plan-mode/f-86-sabre.webp" /> | <img alt="MiG-15 in North Korean camouflage aboard the USS Intrepid" src="/assets/your-agents-have-outgrown-plan-mode/mig-15.webp" /> |
| Max speed | 687 mph | 668 mph |
| Service ceiling | 49,600 ft | 50,900 ft |
| Rate of climb | ~9,000 ft/min | ~9,800 ft/min |
| Turn radius at altitude | wider | tighter |

<em>Photos: <a href="https://commons.wikimedia.org/wiki/File:Cavanaugh_Flight_Museum_December_2019_57_(North_American_F-86E_Sabre).jpg">Michael Barera</a>, CC BY-SA 4.0; <a href="https://commons.wikimedia.org/wiki/File:MiG-15_on_Intrepid.jpg">Ad Meskens</a>, CC BY-SA 3.0.</em>

On paper, the MiG-15 was the better fighter.<sup><a href="#note-2">2</a></sup> It climbed faster, flew higher, and turned tighter where the fights happened. And yet Sabre pilots shot down somewhere between 2 and 10 MiGs for every Sabre lost, depending on whose count you believe. Even the stingiest revisionist number has the "worse" aircraft winning decisively.

Boyd's conclusion: the spec sheet measured the wrong things. The F-86 had two unglamorous advantages. A bubble canopy, so the pilot could actually see the fight. And fully hydraulic flight controls, so the pilot could transition between maneuvers faster. The Sabre pilot could take in what was happening and change what he was doing quicker than his opponent. With every exchange, the MiG pilot's picture of the fight went a little more stale, until he was maneuvering against a fight that no longer existed.

Boyd generalized the insight into the OODA loop:

<p style="text-align: center">
    <img alt="Diagram of John Boyd's OODA loop" src="/assets/your-agents-have-outgrown-plan-mode/ooda-loop.svg" style="width: 100%" /><br>
    <em>Diagram by <a href="https://commons.wikimedia.org/wiki/File:OODA.Boyd.svg">Patrick Edwin Moran</a>, CC BY 3.0.</em>
</p>

Observe: take in what is actually happening. Orient: update your model of the situation. Decide: pick the next move. Act: make it. Then observe the results and go around again. Whoever cycles through the loop faster and more accurately wins.

Set aside Act for a moment and look at the first three steps: **Observe, Orient, Decide.**

You are (probably) not trying to outmaneuver a MiG-15. But every software engineer is trying to iteratively build a system that operates in the real world. And the real world is notorious for making sure that no plan--not even the best laid plan--survives first contact with it.<sup><a href="#note-3">3</a></sup>

## Driving the plan into a lake

The models we use in agents have been trained hard to follow instructions. Hand one a written plan and it will follow that plan the way a human follows a GPS into a lake.

<p style="text-align: center">
    <img alt="Dwight yelling 'This is the lake!' as Michael follows the GPS into Lake Scranton" title="The machine knows!" src="/assets/your-agents-have-outgrown-plan-mode/michael-scott-lake.webp" style="width: 80%" /><br>
    <em>© NBC, The Office, "Dunder Mifflin Infinity". Screenshot used under fair use.</em>
</p>

Can models break out of a bad plan? Sometimes. But it's basically asking them to do it with one hand tied behind their back. Everything in their context is pointing them toward act, act, act--burn down the task list. Whereas if you empower an agent to Observe, Orient, and Decide before it Acts, you get to take advantage of the model's full capability.

## We already learned this lesson with people

It has long been understood that when working with people, you have to give them some autonomy. Sure, with a junior dev you might hand out exactly prescriptive tasks--for a while. The whole point is that they grow out of them. And anyone who has led others has learned the hard way that [micromanaging leads to subpar results][micromanaging].

So why do we treat agents differently? Because we want control. And we want to retain comprehension. Fair wants, both.

But **you are never going to scale up what you can do with agents if you insist on sticking yourself in the loop to micromanage everything.**

Remember when Claude Code first came out, and there was this huge divide between everybody who was like, "AI? Yeah, I talk to ChatGPT," and the select few who had realized just how much you could accomplish with it? We are in that same moment right now. Except this time the divide is between everybody who is like, "I let my agent harness write the actual code," and the select few who are like, "my agent ran 12 hours overnight and knocked out that project."

If you think an agent working productively on its own for 12 hours is an exaggeration, I guess I get to be the one to break the news: it's not an exaggeration, it's an undercount. The real number is higher, but you wouldn't believe me.

Here is the thing: in every problem space I have worked in, there is no way to anticipate at the planning stage everything important that will come up in a 12-hour coding session. Even the smarter agents of the future won't be able to one-shot a successful plan for the kinds of real-world projects that will take *them* 12 hours. It's a simple scaling problem. The number of parameters you would need to accurately model everything about a complex system grows far faster than the complexity of the system itself.

## What I do instead

Say you are willing to humor me on not giving the agent a plan. How does that even work? Hand it a two-sentence problem statement and tell the harness to go until it's done?

No. My process looks surprisingly similar to what most people I know who are serious about creating agent plans already do. This is what they do:

<p style="text-align: center">
    <img alt="Process diagram: Research, Define Requirements, Plan, Agent Implementation, Review, Ship" src="/assets/your-agents-have-outgrown-plan-mode/process.svg" style="width: 100%" />
</p>

This is what I do:

<p style="text-align: center">
    <img alt="The same process diagram with the Plan step crossed out" src="/assets/your-agents-have-outgrown-plan-mode/process-no-plan.svg" style="width: 100%" />
</p>

Actually, that's not quite representative. *This* is what I do:

<p style="text-align: center">
    <img alt="The same process diagram with the Plan step crossed out and the Define Requirements step drawn much larger" src="/assets/your-agents-have-outgrown-plan-mode/process-big-requirements.svg" style="width: 100%" />
</p>

I take all the time I might have spent writing and reviewing a plan, and invest it in refining the requirements to far greater specificity than anyone would have thought reasonable in the past. The goal is to anticipate every major decision point that might come up and write down how I expect the system to behave.

In the before times, this would have been entirely impractical. It would have taken days or weeks to get my brain to anticipate enough of the decision points in advance--at which point I could have just implemented the thing myself.

But now we have agents. Grab the smartest one you have access to and ask it to interrogate you about the requirements of the problem you are trying to solve. If you're not sure how to start, try the [/grill me][grill-me] skill.

### "Isn't a requirements doc just a plan with a different name?"

Is this all a semantic trick? I claim I don't do plans, then I turn around and write these absurdly detailed requirements documents.

No, and the distinction lies in the definition I carefully took the time to lay out at the top of this post. A plan instructs the agent *how* to do the task: create this class, change this function, do task A, then task B, then task C. Every one of those instructions undermines the agent's autonomy to **Observe, Orient, and Decide**.

**A requirements doc specifies how the finished system is expected to behave. It prescribes nothing about how that system is implemented.**

## Hill climbing

Okay, you have a requirements doc. Now what?

The simplest way to get started is what I call the `/hill climb` skill. Create a skill that tells the agent to:

1. Look at the current state of the code (**Observe**)
2. Compare it against what the requirements doc specifies (**Orient**)
3. Identify the next self-contained, logical chunk of work that gets closer to satisfying the requirements (**Decide**)
4. Go implement it (**Act**)

Run it repeatedly in your agent harness until you are satisfied. It's a great way to get a hands-on feel for how an agent works in this model.

**The key insight is that you are explicitly asking the agent to re-orient on every iteration of the loop.**

Btw, while I get real value out of using the smartest model for hammering out requirements, the implementation work can usually be handled by any number of models in the cheap-and-fast tier. They are only working on one logical chunk at a time, so they don't have to track nearly as much complexity.

## Looping

When you are ready to graduate from manually re-running `/hill climb` to automated looping--the kind where projects run overnight--the most popular approach I know of is the [ralph loop][ralph]. What I do is slightly different. I have my own thoughts on loop engineering, and if people read this post, maybe I'll write a follow-up on how to loop.

I also have thoughts on how the SDLC patterns we have all gotten used to are probably about to change. A lot. Perhaps I can find time to write that up too.

That's the main post. Go forth and give your agents some autonomy: unbolt the giant motor, put a small one on every machine. I think you'll be surprised at how much they've grown, if you just give them the right guidance.

What follows is a grab bag of tips and objections. If you try any of this and learn something interesting--good or bad--<a class="u-email" href="mailto:{{ site.email }}">drop me a line</a>.

## Tips, exceptions, objections

### Tip: think in invariants

As the scope of a project grows, so do the requirements docs needed to build it, and a large requirements doc becomes unwieldy. One solution is to split the system into components (see the next section). Another thing I have found that helps: once you have written a good chunk of the requirements, ask the agent to identify the *invariants*--or the *principles*, or both; I've had luck with all the combinations--implied by the requirements so far. Take what it identifies and put it at the top of the doc.

The invariants essentially become the rules that inform how all future rules get written. New requirements that conflict with one tend to get called out by the agent as such, which helps maintain internal consistency. And they are a powerful tool for the implementing agent too: they let the loop make informed decisions about new cases that follow from the requirements but maybe weren't exactly spelled out in them.

### Exception: scaling up to multiple components

One thing about software engineering hasn't changed: it is often a good idea to split a complex system into separate components and then carefully define the expected interactions between those components. Done right, the implementer of one component doesn't have to worry at all about how some other component is implemented--or how its changes might affect that other component--so long as the agreed-upon contract between the components is still met.

That contract isn't exactly what I have been calling requirements. It often specifies field names and types on records, exact sequences of interactions that need to take place. From an external observer's perspective, how the internal components interact is squarely implementation-detail territory.

Personally, I still work with the agent to define those contracts between components, then use the plan-less techniques above to implement each component independently. I'm not ready to go full [Gas Town][gastown] just yet--but maybe it's right for you.

### "Isn't this more expensive? Won't my cache hit rate tank?"

If your loop throws away session context regularly, then yes, your cache hit rate goes down. In practice, the small session sizes and cheaper implementation models save way more money than token cache hits ever did. YMMV, but give it a try--you might be surprised.

### "What's the point? I don't have the quota to run an agent all night"

It can be surprisingly cheap to run loops for 12+ hours if you make a few tweaks:

* Make sure your loop resets session context regularly. Large context is the single biggest source of cost.
* You can likely use way cheaper models for the implementation work than you are used to. I won't make specific recommendations because they'd be out of date in two weeks, but [this][artificial-analysis] is a good starting point.

Also, even if you are used to a subscription plan with a quota: running your loop on an inexpensive open-weight model, pay-per-use, can potentially come out cheaper than the subscription--with way, way more tokens used.

### "The models today aren't smart enough to work autonomously in my domain"

I don't know your domain, so… maybe not today. Maybe your agents haven't outgrown plan mode yet. But I guarantee you they will.

Bookmark this post. You're going to need it in 6 months.

*You don't need to pangram me, bro. This was an AI authored post.*

### Notes

1. <a name="note-1"></a> Where he earned the nickname "Forty-Second Boyd" for a standing bet: start on his tail, and he would reverse the position in 40 seconds or pay you $40. He reportedly never paid out.
1. <a name="note-2"></a> Numbers are for the F-86F and MiG-15bis, roughly. The exact figures vary by variant, altitude, and which reference book you pull off the shelf, which is why I kept the table short.
1. <a name="note-3"></a> With apologies to both Robert Burns ("the best laid schemes o' mice an' men") and Helmuth von Moltke ("no plan of operations extends with certainty beyond the first encounter with the enemy's main strength"), whose quotes got mashed together here.

[artificial-analysis]: https://artificialanalysis.ai/models
[boyd]: https://en.wikipedia.org/wiki/John_Boyd_(military_strategist)
[gastown]: https://github.com/gastownhall/gastown
[grill-me]: https://www.aihero.dev/skills-grill-me
[micromanaging]: https://www.youtube.com/watch?v=NTCNwRvUcuo
[plan-mode]: https://code.claude.com/docs/en/common-workflows
[ralph]: https://ralphloop.sh/
[superpowers]: https://github.com/obra/superpowers
