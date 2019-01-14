---
layout: post
title: "A Pattern For Cancelling Fetch API Requests"
date: 2019-1-14
tags: javascript async await cancellation pattern
---

There is a fairly reproducible bug in [outlook.office.com](https://outlook.office.com/) that occurs when you quickly switch back and forth between Calendar and Mail while everything is still loading in:

![async bug in outlook][outlook-bug]{: .light-border }

Outlook thinks you are in the Calendar when actually it is the Mail section that loaded in last. The navigation basically stops working at that point.

I'm picking on Outlook because it is a major web application that presumably has a large quality assurance team behind it. But once you start to look for these out-of-order execution bugs, you can see them pop up in just about every JavaScript application.

<!--more-->

---

It is easy to see how these bugs get introduced. The user clicks on X, so your application starts to load in X, probably by making a network request. When X finally loads the application displays it. But what if, while X is still loading, the user clicks on Y? Well, X started first, so it probably loads first, followed by Y. Basically what the user wanted.

"It worked when I tested it."

"Cool. 🚢 it."

It is the rare developer that stops and asks, "wait, what if Y loads in before X?"<sup><a href="#note-1">1</a></sup> Even though, if asked, we all know that *just because the requests were fired off in a certain order that does not guarantee they will asynchronously finish in the same order*.

### Debouncing

If you are thinking, "I know how to fix it! We need to debounce click inputs on X and Y," you would be close. But also *wrong*.

[Debouncing][debounce] can often smooth over out-of-order execution issues. And it definitely can help with performance and efficiency. However, debouncing does not prevent out-of-order execution bugs in the general case.

Let's say we debounce clicks on X and Y. The user clicks on both, but we debounce the first click on X so that only Y starts to load in. So far so good. Now what happens when the user clicks on X again—after debouncing took place *but before Y finishes loading in*? We still are open to the possibility of out-of-order execution bugs. The only difference is we have made it slightly less likely.

### Async Cancellation

There is no getting around it. We need a way to prevent subsequent (async) logic from running for all but the most recent request.

The easiest way to do that is to *cancel* the previous request.<sup><a href="#note-2">2</a></sup> Here is what that looks like using the [fetch API][fetch]:

```javascript
let abortController = new AbortController();

const loadData = async (url) => {
  abortController.abort(); // Cancel the previous request
  abortController = new AbortController();

  try {
    let response = await fetch(url, { signal: abortController.signal });
    let data = await response.json();

    updateUI(data);
  }
  catch (ex) {
    if (ex.name === 'AbortError') {
      return; // Continuation logic has already been skipped, so return normally
    }

    throw ex;
  }
};
```

We use a variable (`abortController`) that is scoped outside of the function in question. That way, no matter how many times the function is called and no matter how many requests are in-flight, the only result that will be displayed is the request that was submitted last.

Problem solved. Thanks for reading.

![fade to black][fade-to-black]

*Wait.*

*Is that really all there is to it?*

### Improving The Pattern

There is nothing at all wrong with the example fetch code. Feel free to use it in your own code.

I can't help but wonder, however, if we could improve on the pattern.

For one, the function that orchestrates making a network request and displaying the result (`loadData` in the above example) also needs to know the specific mechanism for how to cancel a network request. I don't know about you, but the applications I work on tend to have many different functions that load in data. So you can end up repeating the same cancellation logic over-and-over.

How might we do better?

Well, what if we abstracted the cancellation mechanism into a decorator function:<sup><a href="#note-3">3</a></sup>

```javascript
const loadData = cancelFetchOnReentry((fetch) => async (url) => {
  let response = await fetch(url);
  let data = await response.json();

  updateUI(data);
});
```

Look cleaner, at least at a surface level. But let's dig in to see what is going on.

If you are not familiar with [decorator functions][decorator-functions], the idea is to take a function and wrap it in another function. The purpose is that the wrapper function—a.k.a. the *decorator*—gets to run immediately before and after the wrapped function runs, having full access to read and modify both the input arguments and the return value.

In the case of our `cancelFetchOnReentry` decorator, the idea is that it can:

<ol style="list-style-type: lower-alpha">
<li>Cancel the previous request whenever <code>loadData</code> is called/re-entered<sup><a href="#note-4">4</a></sup></li>
<li>Swallow the <code>AbortError</code> that gets raised for canceled requests</li>
</ol>

Enough talk. Let's look at how we could implement it:

```javascript
const cancelFetchOnReentry = (wrappedFunc) => {
  let currentAbort = new AbortController();

  return async (...args) => {
    currentAbort.abort();
    currentAbort = new AbortController();

    let mySignal = currentAbort.signal;

    const injectedFetch = (input, init) =>
      fetch(input, { ...init, signal: mySignal });

    try {
      await wrappedFunc(injectedFetch)(...args);
    }
    catch (ex) {
      if (ex.name === 'AbortError') {
        return; // Request has been canceled, so do nothing
      }

      throw ex;
    }
  };
};
```

To see what is going on, we can compare it to the original code side-by-side:

```javascript
                                    | const cancelFetchOnReentry = (func) => {
let ac = new AbortController();     |   let ac = new AbortController();
                                    |
const loadData = async (url) => {   |   return async (...args) => {
  ac.abort();                       |     ac.abort();
  ac = new AbortController();       |     ac = new AbortController();
                                    |
  let signal = ac.signal;           |     let signal = ac.signal;
                                    |
                                    |     const injectedFetch = (input, init) =>
                                    |       fetch(input, { ...init, signal });
                                    |
  try {                             |     try {
    let r = await fetch(            |       await func(injectedFetch)(...args);
      url,                          |
      { signal });                  |
    let data = await r.json();      |
                                    |
    updateUI(data);                 |
  }                                 |     }
  catch (ex) {                      |     catch (ex) {
    if (ex.name === 'AbortError') { |       if (ex.name === 'AbortError') {
      return;                       |         return;
    }                               |       }
    throw ex;                       |       throw ex;
  }                                 |     }
};                                  |   };
                                    | };

```

(Sorry, you may need a non-mobile display for the side-by-side formatting.)

All the same logic is still there. The data loading part has been extracted out to the wrapped function, while all the cancellation logic lives in the decorator. The only other difference is that we inject a specially modified version of `fetch` that automatically gets passed the `signal` owned by the decorator.

There are still a couple things we can improve though.

### Redux Thunk

In React applications, the [Redux Thunk][redux-thunk] library is commonly used for orchestrating async operations, such as making a network request and storing the result. Here is the same example we have been using, re-written for Redux:

```javascript
const loadData = (url) => async (dispatch) => {
  dispatch({ type: 'LOAD_DATA', status: 'pending' });

  let response = await fetch(url);
  let data = response.json();

  dispatch({ type: 'LOAD_DATA', status: 'success', data });
};
```

This code does not support cancellation (yet). It would be nice if we could re-use the `cancelFetchOnReentry` pattern here. However, if you pay close attention to the new `loadData` function signature, you might see the issue with that.

Redux Thunk functions have a [curried][currying] signature. There is an outer function that defines whatever parameters your code needs (`url` in our example). The outer function then needs to return an inner function that accepts the `dispatch` parameter, which allows your code to dispatch Redux actions. It is the inner function that will do all the work when called. It is also only the inner function that can be `async`.

So we could try wrapping the inner function in `cancelFetchOnReentry`:

```javascript
const loadData = (url) =>
  cancelFetchOnReentry((fetch) => async (dispatch) => {
    // ...implementation...
  });
```

Everything will run without error. However, no cancellation will ever take place. That is because a new instance of `cancelFetchOnReentry` (and hence a new `AbortController`) will be created every time you call `loadData`, which means new calls to `loadData` have no way to cancel previous calls to `loadData`.

We could try wrapping the outer function in `cancelFetchOnReentry`:

```javascript
const loadData = cancelFetchOnReentry((fetch) => (url) =>
  async (dispatch) => {
    // ...implementation...
  });
```

However that doesn't work for more obvious reasons—it turns the outer function into an `async` function, which breaks Redux Thunk.

Remember earlier when we said that `cancelFetchOnReentry` really does two things? Well what if we split the decorator into two functions:

```javascript
const loadData = cancelFetchOnReentrySync((fetch) => (url) =>
  swallowCancellation(async (dispatch) => {
    dispatch({ type: 'LOAD_DATA', status: 'pending' });

    let response = await fetch(url);
    let data = response.json();

    dispatch({ type: 'LOAD_DATA', status: 'success', data });
  }));
```

The two functions are:

- `cancelFetchOnReentrySync` – responsible for canceling the previous request
- `swallowCancellation` – responsible for swallowing the `AbortError`

And like that, we can re-use the same decorator to work with Redux Thunk.

__That may have been a long detour if you have no plans to use Redux Thunk.__ However, personally I have more confidence in a pattern when I see it re-used in different contexts. In this instance, we saw how `cancelFetchOnReentry` actually handled two different responsibilities, and by splitting them into two functions we made the code more general.

Of course, for the common case we can still have a `cancelFetchOnReentry` function defined as the combination of the two:

```javascript
const cancelFetchOnReentry = (wrappedFunc) => cancelFetchOnReentrySync(
  (fetch) => swallowCancellation(
    wrappedFunc(fetch)
  )
);
```

### Implementation

Having gone over all the design considerations, we can now look at the full implementation:

```javascript
const cancelFetchOnReentrySync = (wrappedFunc) => {
  let currentAbort = new AbortController();

  return (...args) => {
    currentAbort.abort();
    currentAbort = new AbortController();

    let mySignal = currentAbort.signal;

    const injectedFetch = (input, init={}) =>
      fetch(input, {
        ...init,
        signal: createLinkedSignal(mySignal, init.signal),
      });

    return wrappedFunc(injectedFetch)(...args);
  };
};

const swallowCancellation = (wrappedFunc) => async (...args) => {
  try {
    await wrappedFunc(...args);
  }
  catch (ex) {
    if (ex.name === 'AbortError') {
      return; // Request has been canceled, so do nothing
    }

    throw ex;
  }
};

const createLinkedSignal = (...signals) => {
  signals = signals.filter(s => !!s);

  if (signals.length === 1) {
    return signals[0]; // Debugging is easier when we can avoid wrapping
  }

  let controller = new AbortController();
  for (let signal of signals) {
    signal.addEventListener('abort', () => controller.abort());
  }
  return controller.signal;
};

const cancelFetchOnReentry = (wrappedFunc) => cancelFetchOnReentrySync(
  (fetch) => swallowCancellation(
    wrappedFunc(fetch)
  )
);
```

There should not be too many surprises. The biggest difference is the new `createLinkedSignal` function, which is used to avoid creating a [leaky abstraction][leaky-abstraction] with the injected `fetch` function. Basically, if the caller passes in a `signal` (in addition to the implicit `cancelFetchOnReentry` signal), we want to honor it.

The full implementation may look intimidating. That is OK. If it is a good abstraction, then you should not have to remember exactly how the implementation works every time you want to use it. As long as you remember how to use it correctly, it will all work out.

### What Is Left?

The pattern described in this post will work for most use cases. However, there is one big gotcha.

Imagine we extend the example we have been using to also get data from another async source that does not use `fetch`:

```javascript
const loadData = cancelFetchOnReentry((fetch) => async (url) => {
  let response = await fetch(url);
  let data1 = await response.json();

  let data2 = await getSomeOtherData();

  updateUI(data1, data2);
});
```

Looks like a harmless change, right?

If `loadData` gets called again while awaiting either the `fetch()` or `response.json()` calls, an `AbortError` will be raised by the original request and everything works as expected. However, what happens if `loadData` gets called again while awaiting the `getSomeOtherData()` call? No `AbortError` will be raised (since `fetch()` has already run), and so `updateUI()` will get called for both the latest request and for the request that was supposed to be canceled. Oops.

The issue is that if we `await` anything other than a `fetch` call, cancellation is no longer guaranteed.

In a future post we will look at how to extend the `cancelFetchOnReentry` pattern to work for more than the `fetch` function. We will see how to make it work for functions that have their own cancellation token / signal pattern. And we will see how to make it work for async functions that lack any kind of cancellation support.

### Notes

1. <a name="note-1"></a> I don't know anyone who uses [formal methods][tla+] to find out-of-order race conditions in frontend/JavaScript logic, but it seems like a good idea.
1. <a name="note-2"></a> Another option is [fast-forwarding][cancellation-vs-fast-forward]. Although, it strikes me not so much an alternative but more like a special case of cancellation.
1. <a name="note-3"></a> My coworker, [Kevin Secrist][kevin-secrist], pointed out that using a decorator like this for synchronization logic is not unlike [synchronized methods in Java][synchronized-methods].
1. <a name="note-4"></a> ["Reentrant"][reentrant] is a computer science term. I am using it loosely here to mean calling an async function again (re-entering it) before a previous call has resolved. Technically `cancelFetchOnReentry` cancels all calls, not just reentrant calls. However, canceling an already resolved call is a no-op, so it is only reentrant calls that are relevant.

[cancellation-vs-fast-forward]: https://medium.com/@dtipson/cancelation-vs-fast-forwarding-in-async-javascript-48b49854e1d3
[currying]: https://en.wikipedia.org/wiki/Currying
[debounce]: https://underscorejs.org/#debounce
[decorator-functions]: https://hackernoon.com/function-decorators-part-2-javascript-fadd24e57f83
[fade-to-black]: /assets/cancel-async-requests-pattern/thats-all-folks.gif
[fetch]: https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API
[kevin-secrist]: https://github.com/kevin-secrist
[leaky-abstraction]: https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/
[outlook-bug]: /assets/cancel-async-requests-pattern/outlook-async-bug.gif
[redux-thunk]: https://github.com/reduxjs/redux-thunk
[reentrant]: https://en.wikipedia.org/wiki/Reentrancy_(computing)
[synchronized-methods]: https://docs.oracle.com/javase/tutorial/essential/concurrency/syncmeth.html
[tla+]: https://www.youtube.com/watch?v=tfnldxWlOhM
