---
layout: post
title: "A Brief Introduction To Vector vs. Raster Graphics With SVG and PNG"
date: 2020-10-12
tags: image raster vector svg png
---

There are [dozens of good articles][vector-vs-raster-search] on vector vs. raster (also called bitmap) graphics. If you like a high-level explanation of concepts, go check those out. If you are weird like me, however, and you prefer a more bottom-up explanation—peeking underneath-the-hood to see how the file formats work—then stick around.

We'll start with `.svg` files, because they can be incredibly simple:

```html
<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <circle cx="8" cy="8" r="6"
          fill="none"
          stroke="black"
          stroke-width="1" />
</svg>
```

Copy that source code into a file, `circle.svg`, open it in a web browser, and congrats—you've created a vector graphics file from scratch! Or, even easier, drop the code into the HTML section of a [Codepen][codepen].

<!--more-->

It should look like this:

<svg width="50%" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <circle cx="8" cy="8" r="6"
          fill="none"
          stroke="black"
          stroke-width="1" />
</svg>

What makes this a vector graphic is that the source data used to render the graphic is specified in terms of lines (of if you want to be fancy, *vectors*), in this case a curved line that closes to form a circle.

It doesn't have to be a circle, we could make it a triangle:

```html
<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <rect fill="white" width="16" height="16" />
  <polygon points="1 2, 14 2, 8 14" stroke="#000000" stroke-width="1" fill="none" />
</svg>
```

<svg width="50%" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <rect fill="white" width="16" height="16" />
  <polygon points="1 2, 14 2, 8 14" stroke="#000000" stroke-width="1" fill="none" />
</svg>

Or a square:

```html
<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="2"
        width="12" height="12"
        fill="none"
        stroke="black"
        stroke-width="1" />
</svg>
```

<svg width="50%" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="2"
        width="12" height="12"
        fill="none"
        stroke="black"
        stroke-width="1" />
</svg>

We aren't limited to closed shapes, either. They just make easy examples. Many kinds of lines are possible.

---

Going back to the square example, notice how there are specific coordinates in the source code. Take the `viewBox`. The `0 0 16 16` specifies a logical coordinate space (0–15 on the x axis, and 0–15 on the y axis) that the coordinates in the rest of the source code are in reference to.<sup><a href="#note1">1</a></sup> The `x` and `y` specify the offset of the square. The `width` and `height` specify the size of the square.

Given those numbers, we would expect the square to take up, 12 / 16, or three-fourths of the image. We would also expect 2/16ths of whitespace on every side, given the `x=2`, `y=2` offset. Eyeballs aren't perfect, but that is more or less what I observe in the image.

Important to note is that the coordinates for that logical space don't represent any specific physical units. For example, here is that same svg file rendered at 16 pixels<sup><a href="#note2">2</a></sup>:

<svg style="margin-top: 24px" height="16" width="16" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="2"
        width="12" height="12"
        fill="none"
        stroke="black"
        stroke-width="1" />
</svg>

Tiny, right?

Logical coordinates ≠ physical coordinates. Now… ultimately, the vector graphic does get translated to physical coordinates, when it is rendered to a screen or maybe when it is printed. But the beauty of vector graphics is that you can __take the exact same file and scale it down to tiny sizes, or up to arbitrarily large sizes__, depending on the need of where is actually rendered, and with no loss of clarity.

Do you know what SVG stands for?

"*Scalable* vector graphics"

Scalable.

That is the key word—why they are useful.<sup><a href="#note3">3</a></sup>

## SVG Files In Practice

We have seen how to make simple shapes: circles, triangles, and rectangles. In may not seem like a lot of tools—basic shapes and lines—but if you combine those basics over and over in creative ways you can create almost any visual effect you can dream of.

[![how to draw meme][how-to-draw-meme-img]][how-to-draw-meme]

I mean, I don't know how to do that. But artists can. They are clever people.

Some artists work by crafting `.svg` files lovingly by hand. Overwhelmingly however, vector graphics are created using some sort of visual editor that exports to `.svg` when the artist is done.

![adobe illustrator screenshot][adobe-illustrator-img]

I should warn you: the typical output of exported `.svg` files is not nearly as pretty as the examples we have been dealing with:

[![source of real world svg file][real-world-svg-source-img]][real-world-svg-source]

All the lines that make up this image are defined using [custom path definitions][path-definition]. It is not fundamentally different from what we have seen so far, just more complicated.

## PNG Files

Let's return to the triangle example from before:

```html
<svg viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <rect fill="white" width="16" height="16" />
  <polygon points="1 2, 14 2, 8 14" stroke="#000000" stroke-width="1" fill="none" />
</svg>
```

<svg width="50%" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
  <rect fill="white" width="16" height="16" />
  <polygon points="1 2, 14 2, 8 14" stroke="#000000" stroke-width="1" fill="none" />
</svg>



## Notes

1. <a name="note1"></a> It's more complicated than this. [This article][viewport] is a good introduction to the details.
1. <a name="note2"></a> More like "pixels". On my high DPI display, one browser "pixel" is represented by multiple pixels on my physical display.
1. <a name="note3"></a> The benefits of SVGs go beyond scalability. For instance, text in the image can be stored symbolically as plain text instead of visual glyphs, which I imagine could benefit accessibility. I said this post is only a *brief* introduction, right?

[adobe-illustrator-img]: /assets/brief-introduction-to-vector-vs-raster-graphics/adobe-illustrator.jpg
[codepen]: https://codepen.io/
[how-to-draw-meme-img]: /assets/brief-introduction-to-vector-vs-raster-graphics/how-to-draw-a-head.jpg
[how-to-draw-meme]: https://knowyourmeme.com/memes/how-to-draw-an-owl
[path-definition]: https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/d
[real-world-svg-source-img]: /assets/brief-introduction-to-vector-vs-raster-graphics/real-world-svg-source.png
[real-world-svg-source]: https://www.flaticon.com/authors/freepik "SVG by Freepik from flaticon.com"
[svg-logo]: /assets/brief-introduction-to-vector-vs-raster-graphics/svg-logo.svg
[vector-vs-raster-search]: https://duckduckgo.com/?q=vector+vs+raster+graphics
[viewport]: http://tutorials.jenkov.com/svg/svg-viewport-view-box.html
