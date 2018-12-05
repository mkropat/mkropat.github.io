---
layout: post
title: "Using The Null Object Pattern With 3rd Party Types"
date: 2018-12-4
tags: javascript dinero nullobject pattern
---

*Feel free to [skip ahead]({{ page.url }}#dinero.js) if you are already familiar with the [Null Object Pattern][null-object]. What follows is a quick introduction to the pattern.*

Imagine you want to format a money object before displaying it to the user, but the problem is that the object might be `null`. Any coder knows how to handle that:

```javascript
const formatMoney = (money) => {
  if (money === null) {
    return '[price unavailable]';
  }
  return money.format();
};

console.log('it costs ' + formatMoney(getPrice()));
```

Nothing wrong with that code, right?

But what if I told you we could simplify the same code to this:

```javascript
console.log('it costs ' + getPrice().format());
```

How would that even work?? How does `.format()` not throw `TypeError: Cannot read property 'format' of null` when `getPrice()` returns `null`?

In one sense it is impossible to avoid throwing an error. However, the funny thing about impossible challenges is how often they become possible after examining one's assumptions.

<!--more-->
----

So we know the `getPrice()` function returns a price object that normally looks something like this:

```javascript
{
  format: () => { /* return the formatted representation of the money */ },
  /* ...other money methods... */
}
```

But what about when the price is unavailable? `getPrice()` has to return `null` so the calling code knows the price is missing. Right? But what if it didn't return `null`?

What if instead—only when the price is unavailable—the `getPrice()` function returned an object that looked like this:

```javascript
{
  format: () => '[price unavailable]',
  /* ...other money methods... */
}
```

Every method that is normally on a money object could be implemented with the minimal behavior we want to occur when the price is unavailable. Technically it might not be a real money object, but if our new object has a corresponding method for every method on the real money object we should be able to fool the rest of the system.

Or in other words... if it quacks like a duck...

[![mechanical duck][mechanical-duck-picture]][vaucanson-duck]

What should we call the new object we just created?

Our new object might not be a real money object, but it is a real object. Yet in other ways it fulfills a purpose similar to `null`, in that it represents something that is missing.

Well... you might call it a "null object".

Yup, you guessed it, we just described the null object pattern.

If you are still not sure where the pattern would be useful, I recommend watching [this talk][null-object] by Sandi Metz.

### <a name="dinero.js"></a> Dinero.js

The example in the previous section is less than contrived. There is a JavaScript library for handling money called [Dinero.js](https://sarahdayan.github.io/dinero.js/). It is, as far as I am concerned, the only way to represent money in JavaScript.

```javascript
let price = Dinero({ amount: 5000, currency: 'USD' });
console.log(price.toFormat()); // $50.00
```

At work we recently implemented pricing on a new screen using Dinero.js. At a high-level our logic looks roughly like this:

```javascript
let productPrice = Dinero({ amount: productPriceFromApi });
console.log('product price', productPrice.toFormat());

let addonPrice = Dinero({ amount: addonPriceFromApi });
console.log('addon price', addonPrice.toFormat());

let unitPrice = productPrice.add(addonPrice);
console.log('unit price', unitPrice.toFormat());

let cost = unitPrice.multiply(desiredQuantity);
console.log('total cost', cost.toFormat());
```

(Where `console.log` is a stand-in for showing something in the UI.)

Alas, if only real world applications were so simple. There is a complication:

```javascript
let productPrice = Dinero({
  amount: productPriceFromApi                   // could be null
});

let addonPrice = Dinero({
  amount: addonPriceFromApi                     // also could be null
});

let unitPrice = productPrice.add(addonPrice);   // also nullable, by extension

let cost = unitPrice.multiply(desiredQuantity); // did I mention that
                                                // desiredQuantity could be null?
```

Basically all the numbers might be available, or they might all be missing, or there could be any combination of some numbers being available and others missing.

Yet in all cases we want missing prices to be formatted the same. We could sprinkle the same `if` check for `null` throughout the code, or we could take advantage of the null object pattern to ensure any logic around missing prices stays in one place.

### Implementing the Null Object

At the beginning of this post, we began to define a null money object. Let's expand on it and make it specific to the Dinero type:

```javascript
const nullDinero = Object.freeze({
  toFormat: () => '[price unavailable]',
  getAmount: () => null,

  add: () => nullDinero,
  subtract: () => nullDinero,
  multiply: () => nullDinero,
  divide: () => nullDinero,

  /* ...rest of methods... */
});
```

Notice that `nullDinero` can be defined as a simple singleton object. `null` is always `null` and `nullDinero` is always `nullDinero`.

Here is where we run into our first complication with introducing the null object pattern on a type (Dinero) that we don't own. The code still doesn't know how to handle `null` money amounts. An example:

```javascript
Dinero({ amount: null }); // throws TypeError: You must provide an integer.
```

The Dinero factory function does not know about our `nullDinero` type and so it can't create one. We will need to introduce our own factory function that can either create a real Dinero object or null Dinero object based on the data:

```javascript
const nullableDinero = ({ amount, ...rest }) =>
  amount === null
    ? nullDinero
    : Dinero({ amount, ...rest });
```

Wherever we need to create Dinero objects, we will have our code call `nullableDinero` instead of calling the `Dinero` factory function directly.

#### Null Propagation

When implementing the null object pattern, it is not always obvious what behavior a given method or property should have. A simple example is a method that returns a string—should it return `null` or the empty string? The hard truth is that there is no single, correct way to implement the null object in all situations. The guiding principle is to give the null object the minimal behavior necessary for it to sneak through the rest of the system—hopefully without causing any other code to blow up. That means the desired behavior for a given method or property depends on how the rest of your code works.

In this case, I have chosen to implement the math operators (`add`, `subtract`, and so on) in a particular way.

Stop and think for a second. What do you expect to happen when you add `null` to a number?

Some languages implement it this way:

```javascript
> 123 + null
null
```

This behavior is called null propagation.

JavaScript does not implement null propagation for numbers.<sup><a href="#note-1">1</a></sup> However, that doesn't mean we can't implement null propagation for our `nullDinero` object.<sup><a href="#note-2">2</a></sup>

The implementation is trivial:

```javascript
{
  add: () => nullDinero,
  /* ...the rest of the methods... */
}
```

Returning to the example from earlier, we can see where this is useful:

```javascript
let productPrice = nullableDinero({
  amount: productPriceFromApi                     // let's say this is null
});
let addonPrice = nullableDinero({
  amount: addonPriceFromApi                       // this can have a value
});
let unitPrice = productPrice.add(addonPrice);     // now returns nullDinero
console.log('unit price', unitPrice.toFormat());  // "[price unavailable]"
```

And like that, everything works out as expected. No `if` statements needed.

### OO And The A.equals(B) Symmetry Problem

Here is a contrived example of a gotcha that comes up in object-oriented languages:

```javascript
class A {
  constructor(value) {
    this.value = value;
  }

  equals(other) {
    return this.value === other.value;
  }
}

class B {
  constructor(value) {
    this.value = value;
  }

  equals(other) {
    return other instanceof B && this.value === other.value;
  }
}

a = new A(123);
b = new B(123);

console.log(a.equals(b)); // true
console.log(b.equals(a)); // false
```

If `a` equals `b`, doesn't that imply that `b` equals `a`? Well, not necessarily in an object-oriented language.

The astute among you might see how this relates to the null object pattern.

Let's go back to the example from earlier:

```javascript
let productPrice = nullDinero;
let addonPrice = someRealDinero;
let unitPrice = productPrice.add(addonPrice);     // becomes the nullDinero
console.log('unit price', unitPrice.toFormat());  // "[price unavailable]"
```

Everything worked as expected. So where is the problem?

Well, what if we flipped what is what:

```javascript
let productPrice = someRealDinero;
let addonPrice = nullDinero;
let unitPrice = productPrice.add(addonPrice);     // kaboom
console.log('unit price', unitPrice.toFormat());  // never runs
```

This code blows up with an exception. Real Dinero objects can be added to other real Dinero objects. Real Dinero objects can be added to null Dinero objects. But you can't add a null Dinero object to a real Dinero object because the real Dinero implementation does not understand what a null Dinero is.

If we owned the implementation of the real Dinero, it would be straightforward to update its code to handle the null object. But we don't. It is a third-party type, remember?

At this point, it would be easy to throw up one's hands and conclude that you can not add the null object pattern to third party types. At least, not without creating a [leaky abstraction][leaky-abstraction]. Or not without spending a lot of effort convincing the third-party owner to update their type to handle your case.

But maybe there is another way.

### Proxy Objects

What if we could extend the behavior of real Dinero objects to be aware of the null Dinero object? Without modifying the original source code?

If you have worked much with dynamic languages, one particular solution might be at the forefront of your mind.

[![mizaru][mizaru-picture]{: .center .three-quarters }](https://commons.wikimedia.org/wiki/File:105-see-no-evil-monkey.svg)

However, in the spirit of [the maxim][three-wise-monkeys], we will not think such [improprietous thoughts][monkey-patching].

Instead, we can create a proxy object that wraps the real Dinero object. It will behave exactly like the real Dinero object for all but the handful of methods we want to extend. As for the handful of methods we extend, we only have to implement logic for the cases we care about. All the rest of the behavior we can delegate to the original method.

Since we already have a factory function, `nullableDinero`, which our code calls to create any Dinero objects, we have one place we can wrap any real Dinero objects in our new proxy object:

```javascript
const nullableDinero = ({ amount, ...rest }) =>
  amount === null
    ? nullDinero
    : wrapDineroToBeNullAware(Dinero({ amount, ...rest }));

const wrapDineroToBeNullAware = (realDinero) => {
  let wrapper = Object.create(realDinero);  // delegate to realDinero by default

  for (let method of ['add', 'subtract']) { // extend specific methods
    wrapper[method] = other =>
      other === nullDinero
        ? nullDinero
        : wrapDineroToBeNullAware(realDinero[method].call(wrapper, other));
  }

  for (let method of ['multiply', 'divide']) {
    wrapper[method] = other => wrapDineroToBeNullAware(
      realDinero[method].call(wrapper, other)
    );
  }

  return wrapper;
}
```

__Note__: we have to wrap the Dinero return value from `add`, `multiply`, etc. in a new `nullableDinero` so that subsequent calls to `add`/`subtract` are also `nullDinero` aware.

Let's try it:

```javascript
let productPrice = nullableDinero({ amount: 5000, currency: 'USD' });
let addonPrice = nullDinero;
let unitPrice = productPrice.add(addonPrice);
console.log('unit price', unitPrice.toFormat());  // "[price unavailable]"
```

And like that, we have extended Dinero, a third-party type, to work with the null object pattern.

### Closing Thoughts

None of the patterns described in this post are must-use. A solution based on straightforward functional decomposition would have been perfectly adequate for the use case.

However, when I look at the real code that I implemented following these patterns, I am pleased with the result. The null object pattern—especially in conjunction with null propagation—simplified the code. The biggest risk was in introducing a leaky abstraction, but that was avoided by using the proxy object pattern. All in all, a successful experiment.

__Update 2018/12/5:__ It turns out the [first version][version-1] of this post had a bug (since fixed) that resulted in a leaky abstraction. Kind of telling, isn't it? I think the logic is good now. It shows the risk of trying to be clever and confident at the same time though 😃

### Appendix: Higher Fidelity Null Objects

The Dinero object is a simple object, as far as [prototypical inheritance][js-object-model] goes. The easiest way to explain what I mean is to show you an example:

```javascript
Dinero() instanceof Dinero;                           // false
new Dinero() instanceof Dinero;                       // still false
Object.getPrototypeOf(Dinero()) === Object.prototype; // true
```

In other words, there is no prototype chain! Beyond `Object.prototype`, that is.

Not all objects you might want to use with the null object pattern will be so simple. Fortunately it is easy to enhance the pattern we already established. Here is how you could define `nullDinero` if there was a Dinero prototype chain:


```javascript
const nullDinero = Object.freeze(Object.assign(
  Object.create(Dinero.prototype),
  {
    toFormat: () => '[price unavailable]',
    getAmount: () => null,

    add: () => nullDinero,
    subtract: () => nullDinero,
    multiply: () => nullDinero,
    divide: () => nullDinero,

    /* ...rest of methods... */
  }
));
```

I also experimented with a [theoretically higher fidelity pattern for implementing a proxy object][alternative-proxy-pattern] However, I cannot see it making any real difference in practice.

### Notes

1. <a name="note-1"></a> JavaScript does have `NaN` propagation though, inheriting the behavior from the float data type.
1. <a name="note-2"></a> Null propagation is not useful in all situations. When you have lots of numbers and calculations you can get a cascade of `null`s propagating, without it being obvious where the original `null` came from. However, I find null propagation to be an elegant way to represent the effects of missing/invalid numbers in the UI.

[alternative-proxy-pattern]: https://gist.github.com/mkropat/3be5d0887b9446056c0e190024c7f227#file-dinero-proxy-b-js
[dinero.js]: https://sarahdayan.github.io/dinero.js/
[js-object-model]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Details_of_the_Object_Model
[leaky-abstraction]: https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/
[mechanical-duck-picture]: /assets/null-object-pattern-3rd-party-types/vaucanson-duck.png
[mizaru-picture]: /assets/null-object-pattern-3rd-party-types/mizaru.svg "Copyright Vincent Le Moign - CC BY 4.0"
[monkey-patching]: https://en.wikipedia.org/wiki/Monkey_patch
[null-object]: https://www.youtube.com/watch?v=29MAL8pJImQ
[three-wise-monkeys]: https://en.wikipedia.org/wiki/Three_wise_monkeys
[vaucanson-duck]: https://en.wikipedia.org/wiki/Digesting_Duck
[version-1]: https://github.com/mkropat/mkropat.github.io/blob/fab2d1c66028504632af96fdb0e7a262ed2a9f0d/_posts/2018-12-04-null-object-pattern-3rd-party-types.md
