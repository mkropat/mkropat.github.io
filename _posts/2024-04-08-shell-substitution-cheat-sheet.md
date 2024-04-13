---
layout: post
title: "Bash/Shell Substitution Cheat Sheet (Command vs. Process Substitution vs. Redirection etc.)"
date: 2024-04-07
tags: shell
---

The premise of Unix is that everything is a file. Such simplicity. Yet somehow when it comes time to write the script to glue everything together, the number of concepts involved explodes:

1. [Pipes] (`cmd | …`)
1. [Redirection][redirections] (`< some.file`)
1. [Command substitution][command-substitution] (`$(cmd)`)
1. [Process substitution][process-substitution] (`<(cmd)`)
1. [Here docs][here-docs] (`<<EOF … EOF`)
1. [Here strings][here-strings] (`<<<foo`)

What gives?

<!--more-->

Plus, because the syntax is so terse,<sup><a href="{{ page.url }}#note-1">1</a></sup> it took me years to wrap my head around when to use all of them. Even then, I would still back myself into abominations like:

```sh
cmd1 < <(cmd2)
```

(**Hint**: would a pipe be more straightforward here?<sup><a href="{{ page.url }}#note-2">2</a></sup> `cmd2 | cmd1`)

I don't remember when it dawned on me that all the different syntaxes basically boil down to making square pegs fit in round holes, and that I could approach any problem as: *(starting shape, desired shape) ⇒ syntax*.

If you find yourself currently confused by the various syntaxes, hopefully I can jump start a better understanding in your brain by visually mapping out the table.

## Bash Substitutions

<style>
table {
  border-collapse: collapse;
  margin-top: 24px;
}

table td {
  padding: 3px 6px;
}

table pre {
  margin: 0;
  padding: 12px;
}

table tr:first-child td {
  border-bottom: 1px solid #ccc;
  text-align: center;
}

table td:first-child {
  border-right: 1px solid #ccc;
  text-align: right;
}
</style>

<table>
  <tr>
    <td></td> <td><b>I need:</b></td> <td>Value Parameter</td> <td>File Parameter</td> <td>STDIN</td>
  </tr>
  <tr>
    <td><b>I have:</b></td> <td colspan="4"></td>
  </tr>

  <tr>
    <td>Constant</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"foo"</span> </code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>&lt;<span class="o">(</span><span class="nb">echo</span> <span class="s2">"foo"</span><span class="o">)</span> </code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>… <span class="o">&lt;&lt;&lt;</span><span class="s2">"foo"</span></code></pre></div></div>
    </td>
  </tr>


  <tr>
    <td>Multi-line<br>Constant</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"foo
bar
"</span></code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>&lt;<span class="o">(</span><span class="nb">echo</span> <span class="s2">"foo
bar
"</span><span class="o">)</span></code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>… <span class="o">&lt;&lt;</span> <span class="no">EOF</span><span class="sh">
foo
bar
</span><span class="no">EOF</span></code></pre></div></div>
    </td>
  </tr>


  <tr>
    <td>Variable</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"</span><span class="nv">$var</span><span class="s2">"</span> </code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>&lt;<span class="o">(</span><span class="nb">printf</span> %s <span class="s2">"</span><span class="nv">$var</span><span class="s2">"</span><span class="o">)</span> </code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>… <span class="o">&lt;&lt;&lt;</span><span class="s2">"</span><span class="nv">$var</span><span class="s2">"</span></code></pre></div></div>
    </td>
  </tr>
  <tr>
    <td>File</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"</span><span class="si">$(</span>&lt; some.file<span class="si">)</span><span class="s2">"</span> </code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"some.file"</span> </code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>… &lt; <span class="s2">"some.file"</span></code></pre></div></div>
    </td>
  </tr>
  <tr>
    <td>Command</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"</span><span class="si">$(</span>cmd arg1<span class="si">)</span><span class="s2">"</span></code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>&lt;<span class="o">(</span>cmd arg1<span class="o">)</span></code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>cmd arg1 | … </code></pre></div></div>
    </td>
  </tr>
</table>

By **Value Parameter**, I mean normal parameters when calling a command. For example, `foo` in this grep command:

```sh
grep -r foo .
```

By **File Parameter**, I mean parameters that are specifically expected to contain a path to a file. The second positional parameter passed to `grep` is a File Parameter. Although a more typical example of when you would need process substitution (`<(cmd)`) is for functionality like `grep`'s `--file` option, which expects a file--`patterns.txt` in the below example--but you may want to be the output of a command instead for whatever reason:

```sh
grep -r -f ../patterns.txt .
```

By **STDIN**, I mean the receiving command will read your data--the output of `tail -f some.log` in the below example--from [standard input][stdin], instead of taking the data as parameters:

```sh
tail -f some.log | grep foo
```


## Bonus: POSIX Substitutions

If your shell script starts with:

```sh
#!/bin/sh
```

Use the following table instead, since it avoids Bash-isms from the above table that won't work in [dash][dash] or [Busybox][busybox].

<table>
  <tr>
    <td></td> <td><b>I need:</b></td> <td>Value Parameter</td> <td>File Parameter</td> <td>STDIN</td>
  </tr>
  <tr>
    <td><b>I have:</b></td> <td colspan="4"></td>
  </tr>

  <tr>
    <td>Constant</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"foo"</span> </code></pre></div></div>
    </td>
    <td>
      Use a <code>mktemp</code> file
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nb">echo</span> <span class="s2">"foo"</span> | …</code></pre></div></div>
    </td>
  </tr>


  <tr>
    <td>Multi-line<br>Constant</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"foo
bar
"</span></code></pre></div></div>
    </td>
    <td>
      Use a <code>mktemp</code> file
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>… <span class="o">&lt;&lt;</span> <span class="no">EOF</span><span class="sh">
foo
bar
</span><span class="no">EOF</span></code></pre></div></div>
    </td>
  </tr>


  <tr>
    <td>Variable</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"</span><span class="nv">$var</span><span class="s2">"</span> </code></pre></div></div>
    </td>
    <td>
      Use a <code>mktemp</code> file
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nb">printf</span> %s <span class="s2">"</span><span class="nv">$var</span><span class="s2">"</span> | …</code></pre></div></div>
    </td>
  </tr>
  <tr>
    <td>File</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"</span><span class="si">$(</span><span class="nb">cat </span>some.file<span class="si">)</span><span class="s2">"</span></code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"some.file"</span> </code></pre></div></div>
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>… &lt; <span class="s2">"some.file"</span></code></pre></div></div>
    </td>
  </tr>
  <tr>
    <td>Command</td> <td></td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="s2">"</span><span class="si">$(</span>cmd arg1<span class="si">)</span><span class="s2">"</span></code></pre></div></div>
    </td>
    <td>
      Use a <code>mktemp</code> file
    </td>
    <td>
      <div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>cmd arg1 | … </code></pre></div></div>
    </td>
  </tr>
</table>

## Notes

1. <a name="note-1"></a> Not to mention that in the pre-ChatGPT days, it was impossible to Google what most of the syntax does unless you happened to know the syntax's *true name*.
1. <a name="note-2"></a> There are subtle implications to using pipes, so I am not saying you should never use `< <(cmd)`, but start with the traditional form that everyone understands (pipes) and only use other forms when there is a specific need.

[busybox]: https://www.busybox.net/
[command-substitution]: https://www.gnu.org/software/bash/manual/bash.html#Command-Substitution
[dash]: https://linux.die.net/man/1/dash
[here-docs]: https://www.gnu.org/software/bash/manual/bash.html#Here-Documents
[here-strings]: https://www.gnu.org/software/bash/manual/bash.html#Here-Strings
[pipes]: https://www.gnu.org/software/bash/manual/bash.html#Pipelines
[process-substitution]: https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution
[redirections]: https://www.gnu.org/software/bash/manual/bash.html#Redirections
[stdin]: https://en.wikipedia.org/wiki/Standard_streams
