---
layout: post
title: "My review of the System76 Oryx Pro (oryp10)"
date: 2022-12-19
tags: linux system76 review
---

I am an odd duck when it comes to taste, laptops included. So it is unlikely this review will be helpful for many people. Do all the following apply to you?

- You love the slick hardware design of Apple-like products
- You love the solid hardware⇄software integration of Apple-like products
- You can't go back to non-"Retina"-quality displays
- You are willing to spend extra money to have everything work out-of-the-box
- You abhor the locked down, untinkerable nature of Apple products, and spyware-laden Windows installs

If so, read on.

<!--more-->

## Choices Background (Skip if you don't care)

Reading my laundry list you would think I am a recovering Apple user or something, but it isn't so. I do run a MacBook at my day-job, so I am well versed in their strengths and weaknesses. But for my personal "get stuff done" machine, Linux is my go-to.

My previous laptop was a Dell XPS 13 (preloaded with Linux 🙌). It successfully checked almost all my boxes. I highly recommend that line if it fits your needs. It died unceremoniously—through no fault of the hardware—so I was on the hunt for a replacement. The 13-inch form factor used to be a great fit when I got stuff done on the go, but these days I get more done from the couch, so a 15-inch display is a better fit.

If necessary, I am willing to hack Linux onto the device I realy want. There never was or will be a "year of Linux on the Desktop". But honestly the past 5+ years have been a damn fine time to run Linux—the software has been great for even longer—but now you can buy high quality Linux desktop hardware too, so that is what I am going to do. (Plus I already [waste way too much time](https://www.codetinkerer.com/2019/08/31/install-lineageos-16-on-oneplus-6.html) hacking custom ROMs onto my phones.)

## Other Options Considered

- Framework
    - This is what everyone told me to buy
    - Their highest quality dispaly was QHD, which I find acceptable
    - But Linux fractional DPI sucks hard last I checked, so in practice you either get super tiny text or super big text
    - That combination made Framework a non-starter for me
- Dell Linux offerings
    - Dell XPS 13 line is *soooo* good
    - But I'm shopping for ~15-inch offerings, and they were kinda meh

So that is how I ended up with my first System76 laptop.

## Hardware

#### Display

The display is beautiful on Linux. If I had one complaint, it's that it is **aesthetically ugly**. I don't mean the display quality—once again, beautiful—I mean it looks like a product designed by a crusty old engineer. You've bolted on this sleek, ultra-narrow bevel display onto a boxy, Alienware-like case. Meh.

#### Case/Hinges

Pretty solid feel, despite some things I heard to the contrary. It's one of the reasons why I stayed away from larger-form-factor laptops for the longest time—shitty hinge quality. Besides the aforementioned aesthetic reservations, I have no complaints here so far.

#### Keyboard

I am not a keyboard geek—especially when it comes to key action. I hear the System76 folks are. My philistine impression is that it is pretty good, maybe the best I've used? I can't really tell.

The keyboard layout is possibly the best 104-key layouts I've seen on a laptop. Feels very intuitive to use, while also fills the laptop space aesthetically. Contrary to the rest of their hardware, System76 knows how to make *aesthetic* keyboards.

#### Ports

There are a kitchen sink's worth of them if that's your thing. Not mine. I much prefer keeping the laptop lines svelte, and using a USB-C hub (like with Macs) or a high quality dock system (like business Dells).

It also annoys me that I finally switched over all my stuff over to USB-C and now I've got a laptop that has two Type-As and only 1 Type-C. Which, hey, at least that is a step up from previous iterations of the Oryx that had 0, from my understanding.

## Hardware⇄Software Integration

#### Hackability

The ability to hack on your own firmware, UEFI boot stuff, etc. is a major, major selling point for me. I will probably never do this, but if you're a tinkerer having the **option** to tinker is almost as good as actually tinkering on it.

To the extent that I looked into it, there are actually 3 pieces:

- coreboot – the thing that lets you UEFI boot
- edk2 – the other thing that lets you UEFI boot (wait?? what is the difference between the two? I don't know)
- system76/ec – the thing that lets you hack your physical keyboard layout (oh, and other things too)

I was able to pull down the code and build it easily enough. That is as far as I got.

#### Hybrid Graphics

With hybrid graphics, you can configure when you launch an application whether to run it using integrated graphics (saving battery) or using the Nvidia card (high performance). This strikes me as a killer feature from System76 that no other Linux offering is capable of handling so slickly.

I have a dedicated Windows PC for gaming, so it is unlikely I will take advantage of this much. And the type of games I would play on a laptop—like the Zachtronics line of games—probably run just fine on integrated graphics.

Just to test it out, I fired up American Truck Simulator. The game plays smoothly on Ultra. However, you really have to play with headphones, because you won't be able to hear anything over the fans taking off in your lap.

#### Touchpad

Touchpad goes under the Hardware⇄Software Integration section because problems with touchpads on Linux are almost always due to sub-par drivers. Like you could have a Windows laptop with a beautifully functioning touchpad, reload Linux on it and then wonder why your touchpad got so janky all of a sudden.

I am happy to report that the touchpad interaction feels great. I generally consider MacBooks to be the gold-standard of touchpads, and I can't notice any appreciable difference between those and the one in the Oryx Pro. Seriously well done, System76.

Small disclaimer: I don't take advantage of multi-touch functionality (beyond 2-finger scroll), so ymmv.

#### Sleep

Probably my biggest gripe with the laptop so far. Sleep doesn't *just work*. Not like I expect a machine to sleep in 2022. The battery will die after like a day after leaving the laptop asleep while unplugged. Opening the laptop back from sleep is painfully slow. It does the super-awkward X11 screensaver thing of showing the old desktop for a second, then showing the lock screen. The machine behaves more like a semi-portable desktop PC with built-in batteries, than it does a laptop. Apple figured out how to do this right at least 15 years ago. Please catch up.

## PopOS

PopOS is the Ubuntu-derived distro created by System76. You can alternatively get Ubuntu preloaded on the laptop if you want.

The first thing I do when I get an Ubuntu laptop is reload it with Linux Mint. My Oryx Pro is the first time in a couple decades that I got a computer and didn't immediately reload the OS. There was no need, it was already a Ubuntu-derived distro that wasn't Ubuntu, and there is no bloat or spyware built-in.

My impressions so far are only favorable. Full disk encryption just works.

If I had one complaint it is that you can't remap <kbd>Caps Lock</kbd> to be another <kbd>Control</kbd> out-of-the-box. Thankfully, this is remedied with an install of the `gnome-tweaks` package. I suppose you could also do it at the embedded controller (EC) level, but I didn't try.

## Overall Impression

Between the case design, specs, and hybrid graphics, it's basically the Alienware of Linux laptops. Because the Linux laptop space is relatively sparse, I am happy to recommend it. In my heart though, I long for someone to make a hackable MacBook.
