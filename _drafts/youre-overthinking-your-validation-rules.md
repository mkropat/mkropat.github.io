---
layout: post
title: "You're Overthinking Your Validation Rules"
date: 2018-6-9
tags: history validation
---

In November of 1929, the French Parliament voted to spend 3.3 billion francs to construct a series of impressive fortifications along the French↔German border.

[![fortifications](/assets/youre-overthinking-your-validation-rules/fort-de-sainghain.jpg)](https://commons.wikimedia.org/wiki/File:Troops_of_51st_Highland_Division_march_over_a_drawbridge_into_Fort_de_Sainghain_on_the_Maginot_Line,_3_November_1939._O227.jpg)

The defenses came to be known as the *Maginot Line*. By the time it was complete in 1935, the cost had grown to 7 billion francs. For comparison: the entire French military budget in 1935 was 7.5 billion francs.

<!--more-->

![expert advice](/assets/youre-overthinking-your-validation-rules/experts-view.jpg)

On May 10, 1940, Germany invaded Belgium and the other Low Countries. German forces crossed into France via the relatively unguarded Ardennes forest on the Belgian↔French border. __German forces had simply gone around the Maginot line!__ By June 14th, Paris was occupied and just over a week later France had surrendered.

[![battle of france](/assets/youre-overthinking-your-validation-rules/battle-of-france.png)](https://commons.wikimedia.org/wiki/File%3AWest_Front_1940Campaign.png)

History is unfairly harsh on the Maginot Line. The plan had its merits. In retrospect, however, we can see that overinvestment in the line would have been better spent elsewhere, and overconfidence in the plan had left French leaders blind to obvious threats.

## Input Validation

Tell a programmer to validate user input and they will happily go off to create a bulwark of rules to keep out bad input.

Surely there must be a well-defined, commonly accepted set of rules to distinguish good input from bad, right? Whether it is a person's name, address, phone number, email, domain name, or anything else.

If you've dealt with much real world data, you know this isn't so:

- __Names?__ There are many [falsehoods programmers believe about names](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/)
- __Addresses?__ Have you ever tried to validate a Hong Kong or Japanese or South Korean address, let alone [weird Western ones](https://www.youtube.com/watch?v=DSG-zxGRkJw)?
- __Phone numbers?__ Google created a [~10,000 SLOC library](https://github.com/googlei18n/libphonenumber) to validate phone numbers—do you think it covers every case?
- __Email addresses?__ Go wrap your head around what an [RFC 5322 compliant regex](https://stackoverflow.com/a/201378/27581) looks like
- __Domain names?__ You better know what a [Punycode](https://en.wikipedia.org/wiki/Punycode) domain is

While it is conceivable that with enough research and perseverance you could create rules that validate the format of user input with near 100% correctness, I am here to tell you it is a waste of effort.

__Remember the Maginot Line? And how the Germans simply went around it? Your users will do the same thing to your perfectly crafted rules.__

I don't care how perfect your email validation is. There is no amount of validation that can stop a user from submitting a perfectly well-formed email address that is *not the user's actual email address*.

Oh, sure, you can make it hard by asking the user to enter their email twice. You can verify the email address by trying to send to it. But you can't prevent the user from submitting an incorrect email address in the first place.

The same goes for names, addresses, and all that. The user can put in something that looks like a name, they can put in an address that actually exists, but validation can't tell you if it is the correct name, or the correct address, or the correct whatever.

So what, right? You didn't have to read this blog to know that validation isn't perfect.

## On the purpose of validation

Here's the thing: once you grok that validation isn't perfect, everything else becomes easier.

For one, you can stop trying to use validation to avoid handling incorrect input. This is an easy trap to fall into:

> "If I just spend more time on my validation rules it will mean there will be less work for handling incorrect input."

Nope. Doesn't work like that. Your requirements either dictate that you verify email addresses with a confirmation email or they don't. Validation rules are not a substitute, not even a partial one.

So if validation can't prevent incorrect input, why do we use it then?

I submit to you that validation exists for two purposes:

1. To prevent input that the system can't process
1. To guide users away from making dumb mistakes

Let's examine each in turn:

## Validation Prevents Unprocessable Input

Imagine you are building an online store that has a shopping cart. When a user adds a product to the cart there is a field that lets them enter the quantity.

It makes sense that a user might enter "1" or "42" or maybe even "0" as the quantity. However, our cart logic is not going to work as expected for a quantity of "-1" or "derp". The language runtime is going to blow up if you try to store either of those values in a natural number type. But even if you are not using strong types, something is not going to work as expected when you try to multiply the quantity by the price in order to display a subtotal.

It doesn't have to be at the language level either. Maybe your code doesn't care what the value of the quantity field is because it calls a downstream API or library that does all the processing. If the downstream API is doing the work–make no mistake–it *will* have validation and/or requirements around what input it can accept, whether explicit or implicit.

Here's what both these cases have in common: the criteria for what input the system can handle is clearly defined by some part of the system itself. Perhaps the criteria is defined by your language (quantity must be an integer), by simple inspection of the code (quantity must be able to be multiplied by the price), or by the documented requirements of a downstream API/library.

Wherever the criteria comes from, __you don't need to invent your own validation rules__. All you have to do is __find the well-defined rules that already exist in your system__ and make your validation logic enforce those rules.

## Validation Helps Users Avoid Dumb Mistakes

Multiple choice test: Which of the following is not a valid email address?

<ol style="list-style-type: lower-alpha">
<li>derp@example.com</li>
<li>herpity.derp@example.co.uk</li>
<li>derp</li>
</ol>

I'm pretty sure I could give this test to random people on the street and they would all guess that "derp" is not a valid email address.

Do your users a favor and don't let them make dumb mistakes. Don't let them accidentally put their email in the name field and their name in the email field.

### Example: Validating an Email Address

Say we wanted to prevent the user from submitting the value "derp" for the email field. What is the most basic validation rule we can add?

In my mind, it is hard to get more basic than this:

> Email must contain a "@"

With this simple rule, we have made it hard for a user to get the email field mixed up with a different field.

If we want to get fancy, we could try and prevent the user from submitting an obviously incomplete email address:

> Email must contain one-or-more (non-whitespace) characters, followed by a "@", followed by one-or-more (non-whitespace) characters

Many sites take this one step further by checking if the part after the "@" looks like a domain:

> Email must contain one-or-more characters, followed by a "@", followed by one-or-more characters, followed by a "`.`", followed by one-or-more characters

I love this example because it shows how good validation rules can be at odds with following the specification. No one has "derp@example" as their primary email address. But there is nothing in the spec that prevents someone from [using a top-level domain for their email][email-tld]!

If we wanted to continue to refine our email validation rule, one option would be to look to the spec, perhaps looking for more things not allowed in a domain name. However...

__You know what would catch way more mistakes and be a lot less work than trying to enforce the spec?__ See if the user typed:

- gmial.com
- gmali.com
- etc.

If the user made a typo in a commonly used mail domain warn the user about it.

I am not suggesting you put this level of effort into every place you accept user input. For email, start with a simple "@" check if you can. Add more rules and warnings when you discover that users are having problems. But don't confuse the actual problems your users are having with validating input against some spec, because the two are often not the same thing.

## How Not To Validate Input

I don't know about you, but the first thing I do when researching a programming task is to Google "how to X", hoping to find a Stack Overflow post that shows the definitive way to do "X".

__Why wouldn't you use the top-ranking result for "how to validate X"?__

The short answer is that there is no one-size-fits-all way to validate any given X. Each system and its users is unique.

But hey, if it works for you, I won't stop you. The whole point of this post is to not spend too much time thinking about validation. Just know that there are a couple of traps to watch out for:

1. The one-size-fits-all solution might not match the actual rules in your system. This can lead to validation passing in the frontend, but failing due a validation error in some subsequent, stricter part of the system. Or it can lead to the frontend over-zealously rejecting input that could have been successfully handled by the rest of the system.
2. It can be hard to evaluate which one-size-fits-all solution is the one, true solution. People often up-vote the solution that is claimed to most closely match "the standard". We've already seen how the most helpful validation can have little overlap with the standard, and, in some cases, even be at odds with the standard.

More generally, I know it can be easy to go down the rabbit hole of evaluating different solutions and debating which one is best. It is almost inevitable when you believe there must be one, true solution, but the criteria for evaluating which solution is most correct is itself open-ended.

That is why I have found more success coming up with validation rules by looking *within* the closed system I am building. I first look for input that will cause the system to blow up or otherwise behave unexpectedly. Following that, I look for validation that will help users avoid the most common of mistakes. Really basic stuff. Start with whatever people had trouble with during hallway usability testing. After you get real users banging on your system, go back in the logs and see if there are common mistakes users are making. Refine your validation accordingly.

There's just something more satisfying about starting with a workable solution that has no false negatives (when perfectly good input fails validation) and adding more cases over time, than starting with the "correct" solution and discovering over time that it has all kinds of false negatives and false positives. You know what I mean?

## Notes

https://warontherocks.com/2015/08/the-danger-of-historical-analogies-the-south-china-sea-and-the-maginot-line/
[army-budget]: https://books.google.com/books?id=lDzCD_C_ipoC&pg=PT330&lpg=PT330&dq=John+Mearsheimer+7.5+francs&source=bl&ots=4sWTa_sVzX&sig=VvgbhYcHeSZemSoU0DdO6GTM5zc&hl=en&sa=X&ved=0ahUKEwjokNfAr9vZAhXIct8KHbrwBcEQ6AEIQzAC#v=onepage&q=7.5&f=false
[maginot-line-general]: https://www.thoughtco.com/the-maginot-line-3861426
[pictures]: https://militaryhistorynow.com/2017/05/07/the-great-wall-of-france-11-remarkable-facts-about-the-maginot-line/

[email-tld]: https://serverfault.com/a/721929
