---
layout: post
title: "Hypothesis: Optimize For Refactoring Discoverability"
date: 2019-10-15
tags: code-style refactoring
---

On the path from junior developer to becoming an experienced developer, an important milestone is being able to write good code. Not just code that works ("correctness"), but code that conveys its intentions ("readable") and code that is easy to evolve ("maintainable"). To try and teach what good code looks like, our industry has come up with formal concepts such as design patterns, design principles (DRY, SOLID) and the like.

It dawned on me that there is something important missing from these teachings.

<!--more-->

I recently had the opportunity to pair program with another developer. He was stuck on a piece of code. He knew it was not ideal but he wasn't sure how to proceed. The code worked, however, it wasn't particularly readable or maintainable. It was complex enough that I couldn't picture what a better end-state would look like. Yet, that didn't stop me from immediately making a series of transformations to the code—transformations not intended to make the code better on their own, but transformations I knew had a decent chance of revealing true improvements. It took time, but the improvements eventually revealed themselves. In the end we were both pleased with the way the code turned out.

Neither of us had a better understanding of the problem space than the other. No design patterns applied in this case. No principles turned out to be particularly relevant. Yet my experience brought something to the table—instincts for which transformations provided the highest expected value. And I think those instincts can be taught.

## An Example

At one time it was common<sup><a href="#note1">1</a></sup> to see functions written this way:

```javascript
const doSomething = () => {
  let var1 = getVar1();
  let var2 = getVar2();

  transform(var1);
  transform(var2);

  anotherTransform(var1);
  anotherTransform(var2);

  doAnotherThing(var1, var2);
};
```

I think of this style as "grouped by operation". You can still find functions written this way. However, I think it has become more common to write them like this:

```javascript
const doSomething = () => {
  let var1 = getVar1();
  transform(var1);
  anotherTransform(var1);

  let var2 = getVar2();
  transform(var2);
  anotherTransform(var2);

  doAnotherThing(var1, var2);
};
```

I think of this style as "grouped by data".

Is one style better than the other? Maybe.

There are objective metrics we *could* use to judge their relative merits. One example is the concept of variable "live time", defined as:

> The total number of statements over which a variable is live. A variable’s life begins at the first statement in which it’s referenced; its life ends at the last statement in which it’s referenced.

—Steve McConell, [Code Complete][code-complete]

In both versions of the code, the live time of `var1` is 7. However, the live time of `var2` differs between the two examples. In the first version, the live time is 6. While in the second version, the live time is down to 4 statements—a measurable improvement.

Does that make the second version inherently better? Perhaps. Reducing live time can help avoid bugs, particularly when the function grows larger than can fit on one screen. But for nice, short functions, I'm not so sure it makes a difference either way. Whatever measurable difference the style makes for *short* functions, it is so insignificant compared to other factors that it doesn't matter. At least, it doesn't matter for evaluating the code quality *in isolation*.

However, I knew there was a difference between the two styles, but I couldn't put the concept into words before now.

### Code Style Can Reveal Refactoring Opportunities

Take the second example again:

```javascript
const doSomething = () => {
  let var1 = getVar1();
  transform(var1);
  anotherTransform(var1);

  let var2 = getVar2();
  transform(var2);
  anotherTransform(var2);

  doAnotherThing(var1, var2);
};
```

If you've spent much time working in this style, you don't need to examine this function closely to identify a refactoring opportunity. Merely squinting at the shape of the function reveals its duplication.


### Different Styles Reveal Different Opportunities

## Notes

1. <a name="note1"></a> One reason for the early popularity of this style was that some compilers required all variables to be declared at the beginning of a function.

[code-complete]: https://en.wikipedia.org/wiki/Code_Complete
