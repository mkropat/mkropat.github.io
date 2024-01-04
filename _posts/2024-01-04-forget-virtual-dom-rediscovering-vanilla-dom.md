---
layout: post
title: "Maybe you don't need React – Rediscovering the Vanilla DOM"
date: 2024-01-04
tags: vanilla js dom
---

![geordiposting meme - virtual dom vs vanilla dom](/assets/maybe-you-dont-need-react-rediscovering-vanilla-dom/geordiposting-virtual-dom-vanilla-dom.webp)

<!--more-->

Too many of my recent posts have been about professional coding. This post will be a change of pace. Now, I am not here to discourage anyone from using React on your next professional project. It is a well designed tool with a well established ecosystem.

It is just that… React has become un-fun.

For me, I can't deal with with the build toolchain that drags down the DX of simple projects. Nor deal with the `node_modules` bitrot when I return to a project after 6 months. For you, perhaps you're don't want to make the stodgy choice when there are so many new frameworks to try out.

## If not React, then what?

Honestly it has never been a better time to go lightweight on the front-end for simple projects. The cornucopia of different tools on offer is impressive in its diversity of approaches. Here are the highlights I've run across:

<br>

| Tool | Description |
|-|-|
| [htmx][htmx] | Get all the dynamic behavior on the front-end without writing custom JS code. Extremely productive in a server-side heavy codebase. |
| [Preact][preact]+[htm][htm] | Write the same React code you're used to--even with JSX-like syntax thanks to htm--but ditch all the bloat. No build step required! |
| [`.innerHTML`][innerhtml] | Now that JS has [Template literals][template-literals], you can render impressively dynamic UIs with 100% vanilla JS. |

There are [a bunch of others][unsuckjs].<sup><a href="#note-1">1</a></sup>

Beyond libraries, it is worth pointing out that you don't need a bundler any more (bye bye, Webpack).<sup><a href="#note-2">2</a></sup> No, I am not suggesting you go back to caveman times and deal with goofy module libraries and `<script>` tag ordering. It is 2024, you can use `import`/`export` [natively from the browser now][javascript-modules].

---

Let's get real though. If we're going lightweight for the fun of it, what is more fun than rolling your own library?

![not invented here](/assets/maybe-you-dont-need-react-rediscovering-vanilla-dom/not-invented-here.webp){: .shrunken-image }

## On DOM Rendering

I'm not going to lie, the rest of this post is the programmer-equivalent of a parent posting baby pictures. The practical bits were the links above. If you keep reading, that's on you.

Vanilla JS is *almost* good enough to write serious UI code. The DOM interface works fine for progressive enhancement or mutating specific elements. It gets overly verbose though when you want to dynamically render whole `<table>`s or `<form>`s.

In case you weren't around before there were JS frameworks like React, I'll show you what vanilla DOM creation looks like:

```javascript
let li = document.createElement('li')
li.className = getLiClass({ editingSelection, todo })

let div = document.createElement('div')
div.className = 'view'

let input = document.createElement('input')
input.checked = completed
input.className = 'toggle'
input.type = 'checkbox'
input.onclick = () => {
  toggleTodo(id)
}
div.appendChild(input)

li.appendChild(div)
return li
```

(You've probably guessed this is for a [TodoMVC][todomvc] app.)

☝️ That is actually only a fraction of the code needed, but it is so painfully verbose that I spared you the rest of it.

With a small amount of library code though, we could easily do this:

```javascript
return li({ class: getLiClass({ editingSelection, todo }) },
  div({ class: 'view' },
    input({
      checked: completed,
      class: 'toggle',
      type: 'checkbox',
      onclick: () => {
        toggleTodo(id)
      },
    }),
    label({ ondblclick: startEditMode },
      title
    ),
    button({
      class: 'destroy',
      onclick: () => {
        destroyTodo(id)
      }
    })
  ),
  form(
    {
      onsubmit: evt => {
        evt.preventDefault()
        saveEdit()
      },
    },
    editField, // reference to a previously initialized element
  ),
)
```

The syntax has almost a JSX like quality to it, except, as you can see, the tag names (`li`, `input`, `label` etc.) are simple function calls. If you want to see it in the full context, check out the [TodoMVC app I implemented][my-todomvc] using this pattern.

By "small amount of library code" necessary for this syntax, I mean [<200 lines of code][tagsjs] (of which at least 100 lines are rote boilerplate).

I'm not the first person to come up with this syntax. Nor the first person to implement a <2 KiB (compressed) UI rendering library. The reason I was excited to share this particular implementation is two-fold:

1. To try to convince you that you can roll your own simple library for your own needs--if nothing else, it is fun
2. To put forward the idea that solving the verbose DOM creation problem is perhaps the minimum viable abstraction
    - Most of the [other lightweight libraries][unsuckjs] try to tack on at least one other bit of functionality
    - For example, many offer the ability to define your own UI components; data binding is also common

Personally, if I wanted a framework I'd go with [htmx][htmx] or [Preact][preact]. They're both ridiculously lightweight and yet I can trust that a codebase written with them will scale gracefully to handle the complexity of a large application.

Going to the minimal extreme, sometimes I need a zero-dependency solution. Assigning to `.innerHTML` using JS template literals works just fine.

However, I keep working on side-projects where I want for something lightweight in between these two. Picture stuff like custom UI forms that I'm injecting into a page with [Tampermonkey][tampermonkey], or one-off dynamic tables injected into otherwise stand-alone, static HTML pages. For those use cases, it has been nice to have some [drop-in code][tagsjs]<sup><a href="#note-3">3</a></sup> that does one thing and __one thing only__--create DOM elements through a convenient API.

## Notes

1. <a name="note-1"></a> I'd like to add a framework to the table that really embraces web components since it strikes me as a fruitful approach, but I personally haven't played around with any of them to know what to recommend.
1. <a name="note-2"></a> To be clear, I am talking about simple and/or small scale projects. There are good reasons to use a bundler on larger projects.
1. <a name="note-3"></a> It would surprise me if anyone wanted to use my `tags.js` code, but just in case a disclaimer: feel free to copy the code and do whatever you want with it. However, I have no intention of running an open source project around it when there are already [too many choices out there][unsuckjs], so save your effort on submitting PRs or feature requests.

[htm]: https://github.com/developit/htm
[htmx]: https://htmx.org/
[innerhtml]: https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML
[javascript-modules]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules
[my-todomvc]: https://github.com/mkropat/todomvc-tagsjs/blob/main/js/app.js
[preact]: https://preactjs.com/
[tagsjs]: https://github.com/mkropat/todomvc-tagsjs/blob/main/lib/tags.js
[template-literals]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals
[todomvc]: https://todomvc.com/
[unsuckjs]: https://unsuckjs.com/
[tampermonkey]: https://www.tampermonkey.net/
