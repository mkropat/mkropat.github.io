---
layout: post
title: "Enable Non-Creepy Mode In Firefox"
date: 2016-5-9
tags: firefox privacy howto
---

<!--more-->

The web is a creepy place.  Ads follow you around.  You're tracked not only by
what you click on, but also what you spend an extra second noticing when you're
scrolling past.  Even when you're not on Facebook, Google, and Twitter, those
companies still know just about everything you read online.  Of course,
companies would never misuse personal data in creepy ways (nor would they ever
sell it to third parties whose names you've never heard of).<sup>1</sup>

The web didn't used to work like this.  It doesn't have to work like this...
wait a minute... __what if we disabled all these new browser features that
enable websites to track us?__

![YouTube with everything disabled](/assets/non-creepy-mode-for-chrome/tinfoil-youtube.png){: .shrunken-image .center }

Oh, that doesn't look quite right.

![full tinfoil hat](/assets/non-creepy-mode-for-chrome/full-tinfoil-hat.jpg){: .center }

So I don't want all my web browsing activity to be tracked by a few big
companies.<sup>2</sup>

But... __I also want to be able to use the modern web.  I want everything to
work without thinking about it.__<sup>3</sup>

The rest of this post is about putting in some work up-front to limit the kinds
of tracking companies can do when you browse the web.  Along the way, we'll
also take some steps to protect against malware and other threats.  In the end,
what you do on the web will be a lot more private and you won't even have to
think about it.

I like to call this way of browsing the web: “non-creepy mode.”

### The Basics

#### 1. Install An Ad-Blocker

No companies more blatantly track you than advertising companies, and there's
no faster way to get your computer infected than a drive-by download from a
malicious ad (malvertising). Let's kill two birds with one stone.

__What You Need To Do__: [Install uBlock Origin][ublock-origin] (or [Adblock
Plus][adblock-plus] or whatever else works)

If you feel bad that you're no longer supporting the sites you visit, feel free
to turn off your ad-blocker on the sites you care about.  Or don't care,
because even reputable sites like the New York Times, BBC, Forbes have all been
tricked into serving malicious ads.

Speaking of turning your ad-blocker off—whether by choice or because the site
you want to visit demands it—it's a good idea to install supplementary tracking
protection.  That way, even when your ad-blocker is turned off, your browser
will still block the tracking mechanisms used by ad companies.<sup>4</sup>

__What You Need To Do__: [Install Privacy Badger][privacy-badger]

Privacy Badger watches website behavior over time and figures out what's
tracking you so it can block it automatically.  It's the epitome of
set-and-forget privacy protection.

#### 2. Sandbox Social Media

I'm sure you've seen social media widgets like these all over the web:

![social media buttons][FIXME]

They can be mildly convenient when you want to share something but
copy-and-pasting feels like too much work.  Unfortunately, they also have an
unsettling consequence on privacy: the widgets "phone home" wherever they
appear.  That Facebook "like" button that appears on a news article about
Facebook selling personal data?  Yeah, Facebook knows you read that
article.<sup>5</sup>

![facebook-referer][FIXME]

__What You Need To Do__: 

Install [Disconnect][disconnect].

#### 3. Get Over Google

#### 4. Embrace HTTPS

### Advanced Steps

#### Whitelist Persistent Cookies

#### Click-To-Play Plugins

#### Use a VPN (On the Road)

#### Miscellaneous Tweaks

### How To Test For Privacy

### tl;dr

1. [ ] Install [uBlock Origin][ublock-origin]
1. [ ] Install [Privacy Badger][privacy-badger]

### Next Steps

If you're on Windows 10, know that it has a bunch of features that track you by
default.  Fortunately, [there's an easy way to turn them all off][set-privacy].



### Notes

1. It's tempting to swear off the internet and these big social media sites altogether.  Then just as quickly you remember that it's how you stay in touch with your social (and family) group, how you find out what's going on, your entertainment, and how you do the most basic things like find out which store/restaurant/business/whatever to buy something from.
2. If you're worried about the government tracking you, this post won't help. [You'll need an entirely different set of tools to protect against that threat model][tails].
3. There's a whole class of browser extensions that give you total fine-grained control of what every website does. I think it's cool that they exist, but...

    ![umatrix screenshot](/assets/non-creepy-mode-for-chrome/tinfoil-umatrix.png "uMatrix screenshot"){: .shrunken-image .center }

4. Some people think that running Privacy Badger alongside an ad-blocker is redundant, but in reality they're quite complementary.  Ad-blockers look at the what—they blacklist patterns  of ads that sites have used in the past.  Privacy badger looks at the how—it blocks behaviors of a site that are clearly meant to track you.  They both catch things that the other might miss.
5. If you're logged in to Facebook, Facebook knows that it was you personally who read it.  If you're not logged in, Facebook still knows that someone at your IP address read it.  Note: not every Facebook/Google+/Twitter/whatever button phones home. Most do, but it does depend on how the site they're on implements the buttons.

### Bibliography


Malvertising:

- http://arstechnica.com/security/2016/03/big-name-sites-hit-by-rash-of-malicious-ads-spreading-crypto-ransomware/
- http://www.securityweek.com/forbes-hit-malvertising-campaign-fireeye
- https://www.wired.com/2015/12/hacker-lexicon-malvertising-the-hack-that-infects-computers-without-a-click/

Various issues:

- https://www.bestvpn.com/blog/12376/why-i-use-ad-blockers-on-all-devices/
- https://www.bestvpn.com/blog/8337/things-go-bump-night-http-etags-web-storage-history-stealing/
- https://www.bestvpn.com/blog/8177/super-cookies-flash-cookies/

Supercookies:

- http://samy.pl/evercookie/

Privacy Testing Tools:

- https://www.maxa-tools.com/cookie-privacy.php

---

[adblock-plus]: https://addons.mozilla.org/en-US/firefox/addon/adblock-plus/
[tails]: https://tails.boum.org/
[disconnect]: https://chrome.google.com/webstore/detail/disconnect/jeoacafpbcihiomhlakheieifhpjdfeo
[privacy-badger]: https://addons.mozilla.org/en-us/firefox/addon/privacy-badger-firefox/
[ublock-origin]: https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
[set-privacy]: https://github.com/hahndorf/Set-Privacy

