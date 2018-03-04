---
layout: post
title: "CSS Specificity Explained In 300 Words"
date: 2018-3-3
tags: css
---

If you've done much CSS, you've probably run into this issue:

```css
/* a rule defined in some common/library code */
.some-component .some-element {
    color: red;
}

/* ...somewhere else in a file you're working on... */
.some-element {
    color: blue; /* doesn't work. why? */
}
```

You added some CSS to make the element blue, but for some reason a CSS rule defined earlier in some library is overriding your style. What gives?

<!--more-->

The answer is that the selector with the higher CSS Specificity __won the game__.

What are the rules of the game, you ask?

1. Count the # of ids (`#some-id` etc.) that appear in each selector. The selector with the most ids wins.
1. If case of a tie, count the # of classes (`.some-class`, etc.). The selector with the most classes wins the tie.
1. If there's still a tie, count the # of tags (`h1`, `p`, etc.). The selector with the most tags wins the tie.
1. If there still isn't a winner, then the selector that appears last wins.

Oh, and btw, if there is an inline style (`style="color: purple"`), that trumps all the above rules and automatically wins.

## Example: Winning the Specificity Game

Imagine some library has annoyingly defined this super-specific selector:

```css
.data-table > tr > td.fancy {
    color: red;
}
```

Look at all those classes and tags! How could we ever make a more specific selector for the table cell??

*Easy.* Add one more class than it:

```css
.some-component .data-table .fancy {
    color: blue;
}
```

Notice how we don't even need all the tag selectors to be more specific. Having 3 classes trumps having 2 classes.

## Wasn't that easy?

I don't know why there are so many explanations for this on the internet that ask people to add 1000 for this and 100 for that and blah, blah. Or worse, explanations that make a [tortured analogy][specificity-wars].

It makes it sound like calculating CSS specificity is this mathematical formula you have to wrap your brain around. When in reality, you can teach anyone that knows how to score a simple card game the rules for CSS specificity in like 5 minutes.

I left out a few details in this post. [Go read the spec][spec] if you need to know how attributes, pseudo-classes, and pseudo-elements fit in to the picture. Don't be afraid. The entire section on specificity is shorter than this post.

[spec]: https://www.w3.org/TR/selectors-3/#specificity
[specificity-wars]: https://stuffandnonsense.co.uk/archives/css_specificity_wars.html
