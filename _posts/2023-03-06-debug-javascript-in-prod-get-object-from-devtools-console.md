---
layout: post
title: "Debugging JavaScript in Production: Get an object from DevTools console"
date: 2023-02-11
tags: javascript
---

The canonical way to get an object while working from the DevTools console is to [set a breakpoint][breakpoint-howto] from the debugger. Once it is hit, hover over the object and select **Store object as global variable**:

FIXME

This works great if you know where to set a breakpoint (in a place with access to the object you want) and you know that the breakpoint will be hit.

Sometimes you aren't so lucky, however. I have another trick that can come in handy in these situations.

<!--more-->

Basically we can list out all the objects 

```javascript
objs = new Set
nameToObj = new Map
getObjName = (obj) => obj.constructor && obj.constructor.name
traverseObjs = (obj) => {
  if (!obj || typeof obj !== 'object' || objs.has(obj)) { return }
  if (obj.nodeName === 'IFRAME') { return } // iframe descendants can cause security errors
  objs.add(obj)
  let name = getObjName(obj)
  if (!nameToObj.has(name)) { nameToObj.set(name, []) }
  nameToObj.get(name).push(obj)
  for (let key of Reflect.ownKeys(obj)) {
    try {
      traverseObjs(obj[key])
    } catch (err) { }
  }
  traverseObjs(Object.getPrototypeOf(obj))
  if (obj[Symbol.iterator]) {
    for (let item of obj) { traverseObjs(item) }
  }
}
traverseObjs(window)
objs = [...objs]
o = Object.fromEntries(nameToObj)
```

```javascript
getObjName = (obj) => {
  let name = obj.constructor && obj.constructor.name
  if (name === 'Object') {
    let str = obj.toString && obj.toString()
    let replacement = str && str.replace(/^\[object ([^\]]*)\]$/, '$1')
    if (str !== replacement) { return replacement }
  }
  return name
}
```

[breakpoint-howto]: https://developer.chrome.com/docs/devtools/javascript/breakpoints/


