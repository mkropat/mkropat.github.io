---
layout: post
title: "Debugging 3rd Party Nuget Packages"
date: 2017-12-06
tags: c# nuget
---

The following is a braindump of what options there are for debugging Nuget
packages not maintained by you. It's not particulary polished, but maybe it'll
help someone.

<!--more-->

So you need two things to step-through code:

1. The souce code, and...
2. The `.pdb` file that was built alongside the `.dll` you want to debug

## 1. Loading the Source Code

You need to tell Visual Studio how to locate the source code for the files you
want to debug. There are a few options here:

- Open the solution that contains the code you want to debug, then attach the
  debuger (__Debug__ → __Attach to Process__) to the running process
- Open your app solution, and add the other `.sln` or project to the app
  solution  (you don't have to commit the changes if you don't want)
- __Untested__: open your app solution, right click on the solution → __Debug
  Source Files__ → add the directory here
- Open your app solution, start debugging then step-in to the Nuget package
  code and Visual Studio will prompt you for the location to the source files
  (I'm not sure it prompts you 100% of the time)

#### How do I find the source code for a given Nuget package?

Unfortunately, there is no standard way for a Nuget package or metadata on the
Nuget site that points from the package to the corresponding source code.

What usally works for me is to go to the Nuget page for the package and click
on __Project Site__. With luck, the site exists and has a link somewhere on it
to Github or wherever the source code lives.

Failing that, I usually pick a class name I know exists in the package and
search Google for `DerpComponent.cs` or search Github directly for the class
name. With luck, the class name is fairly unique and the source code has been
indexed by one of the search engines.

__Note__: there is not a 1-1 relationship between Nuget packages and source
code repositories. One repo may contain the source code for many Nuget
packages. This can make it hard to know if you're looking at the right repo
when the code you want is buried 5 folders deep alongside a bunch of other
stuff.

#### What if I don't have the source code?

__Untested__: Try using [dotPeek's Symbol Server
feature](https://www.jetbrains.com/help/decompiler/Using_product_as_a_Symbol_Server.html)

#### How do I set a breakpoint on library code that hasn't been added to the solution?

__Untested__—I haven't actually gotten this to work but it seems like it might
work.

1. Open the __Breakpoints__ window (__Debug__ → __Windows__ → __Breakpoints__)
2. Click on __New__ → __Function Breakpoint__
3. Enter the full `Namespace.Class.Method` name of the function you want the
   debugger to break on
4. Cross your fingers

## 2. Loading the Symbols (.pdb) File

In order to debug a `.dll` file, you must have the corresponding `.pdb` file
from the __exact same build__. Visual Studio correlates the two files using a
combination of the file name and a matching GUID stored in the `.dll` and
`.pdb` file that gets regenerated for each build.
([Source](https://www.wintellect.com/pdb-files-what-every-developer-must-know/))

There are a few ways to get a usable .pdb file. Each option is explained below.

### 2a. Nuget Symbols Package

When publishing a Nuget package, the author has the option to additionally
publish a [symbol
package](https://docs.microsoft.com/en-us/nuget/create-packages/symbol-packages),
which contains the corresponding `.pdb` file.

To tell Visual Studio to automatically load `.pdb` files in symbol packages I
think you have to do one of 2 things (and I'm not sure which one it actually
is):

- ["Enable Source Link support" and/or "Enable source server support"](https://blog.ctaggart.com/2017/03/enable-source-link-support-announcing.html)
- [Add the symbol server url to the Symbol file location list](https://msdn.microsoft.com/en-us/library/ms241613.aspx)

You may have noticed I don't really know how to do this, and that's because I
find so few packages publish symbols (correctly?) that this has never worked
for me.

#### How do if I know if the Nuget package I want to debug publishes a symbol package?

You don't :( At least, [I don't think there's an easy way to
know.](https://stackoverflow.com/q/47680025/27581) You can take a look at the
project site and maybe it will say something if it publishes symbols?

### 2b. Load the .pdb files manually

Perhaps you were able to download the `.pdb` files from the website or
something. Perhaps the `.pdb` files are available on a file-share put there by
the build server. However it happened, you have access to the `.pdb` files. Great.

1. Start debugging your application in Visual Studio
2. Open the __Modules__ window (__Debug__ → __Windows__ → __Modules__)
3. Find the `.dll` you want to debug (it helps to sort by Name)
4. Right click on the `.dll` and select __Load Symbols__
5. Browse to the directory containing the corresponding `.pdb` file

__Note__: You can enter network paths (for example:
`\\buildserver1\c$\builds\whatever\`) in the file window, so you don't have to
copy the `.pdb` files to your local machine.

You should now be able to set breakpoints and have them be hit.

### 2c. Create the .pdb files yourself

What if you can't find the `.pdb` file for the `.dll` file you want to debug?
Or what if you don't have the exact right version of it? You're kind of out of
luck, but there is one option...

You have access to the source code, right? So build the `.dll` yourself, then
you'll have the right `.pdb` file for it.

Figuring out how to build random codebases is outside the scope of this
document. You'll have to figure that out for yourself.

Once you've built the `.dll`, you now need to update your app to load the
`.dll` you built (instead of the version that Visual Studio downloaded from
Nuget). I've done this two different ways the old way, and the new way.

#### Old Way

Old versions of Nuget create a `packages` folder in the root of your solution
where it downloads and unzips Nuget packages. If you find the corresponding
Nuget package folder, you can overwrite the Nuget `.dll` files with the ones
you built. When you build your app the `.dll` files you dropped in there should
be copied into the output directory of your app.

#### New Way

New versions of Nuget don't create a `packages` folder anywhere as far as I can
tell.

That leaves only two other ways I know how to override the `.dll`:

1. Manually copy your `.dll` into the output directory everytime you build the
   solution
2. Manually remove the Nuget references from the project and replace it with a
   hardcoded reference (__Solution Explorer__ → __Dependencies__ → __Add
   Reference__ → __Browse__)

You may run into a few different issues doing #2:

- If other Nuget packages depend on the Nuget package you're trying to remove,
  you would have to remove the whole tree of Nuget packages and manually add
  them, which doesn't sound like fun
- With new Nuget, it automatically takes care of binding-redirects, but if you
  manually add the reference you will have to manually add binding redirects if
  necessary
- I've seen Visual Studio error out with "reference is invalid or unsupported"
  when trying to add references this way. I was able to work around it by
  manually editing the `.csproj` file and add a reference that looks like:
  `<Reference
  Include="Herp.DerpComponent"><HintPath>\some\path\to\DerpComponent.dll</HintPath></Reference>`

However you do it, once you get the app running so that it references the
re-built `.dll`, you should be able to debug by following the directions in
__2a__.

## See Also

- [Visual Studio Remote Debugging
  Notes](https://gist.github.com/mkropat/5fc3cf7d9e83519ed98e) - some notes I
  wrote a while back specifically for remote debugging. A little out-of-date,
  but there's still good info there.
