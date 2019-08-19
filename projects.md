---
layout: page
permalink: /projects
title: Projects
---

Some stuff I've published:

<div class="portfolio">

<div class="portfolio-entry">
  <div class="portfolio-feature">
    <a href="https://github.com/mkropat/dapper-invoice"><img src="assets/index/dapper-invoice.png"/></a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://github.com/mkropat/dapper-invoice">Dapper Invoice</a></h4>
    <p>billable-time invoice template featuring style over substance</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature">
    <a href="https://www.codetinkerer.com/podcast/"><img src="assets/index/get-podcast-link.png"/></a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://www.codetinkerer.com/podcast/">Get Podcast Link</a></h4>
    <p>look up the feed URL given an iTunes or website link</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature">
    <a href="https://www.codetinkerer.com/is-shell-portable/">
      <img src="assets/index/is-shell-portable.png" />
    </a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://www.codetinkerer.com/is-shell-portable/">Is Shell Command __ Portable?</a></h4>
    <p>a survey of what shell commands are available from <tt>/bin/sh</tt> on different platforms</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature sh">
    <a href="https://github.com/mkropat/jumpapp">
      <pre><code>Usage: jumpapp [OPTION]... COMMAND [ARG]...

Jump to (focus) the first open window for an application, if it's running.
Otherwise, launch COMMAND (with opitonal ARGs) to start the application.

Options:
-r -- cycle through windows in reverse order
-f -- force COMMAND to launch if process found but no windows found
-n -- do not fork into background when launching COMMAND
-p -- always launch COMMAND when ARGs passed
      (see Argument Passthrough in man page)
-L -- list matching windows for COMMAND and quit
-t NAME -- process window has to have NAME as the window title
-c NAME -- find window using NAME as WM_CLASS (instead of COMMAND)
-i NAME -- find process using NAME as the command name (instead of COMMAND)
-w -- only find the applications in the current workspace</code></pre>
    </a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://github.com/mkropat/jumpapp">jumpapp</a></h4>
    <p>run-or-raise application switcher for any X11 desktop</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature">
    <a href="https://github.com/mkropat/MlkFileHasher"><img src="assets/index/MlkFileHasher.png"/></a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://github.com/mkropat/MlkFileHasher">MlkFileHasher</a></h4>
    <p>simple, stand-alone file hashing utility for Windows</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature powershell">
    <a href="https://github.com/mkropat/MlkPwgen">
      <pre><code>PS > 1..5 | foreach { New-Password }
xVs7tYANfs
FGQ4hF29Oe
QHffH4QRUE
ai1AaBqSMe
Dd7cnAG8a8
PS > New-Password -Lower -Upper
HccNubILPl
PS > New-Password -Digits -Length 6
470114
PS > New-Password -Lower -Upper -Digits -Symbols
y3iF(g(xUw
PS > 1..5 | foreach { New-PronounceablePassword }
NaternNeam
LumLictles
StZattlate
InfeHascal
Tighampers</code></pre>
    </a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://github.com/mkropat/MlkPwgen">MlkPwgen</a></h4>
    <p>secure random password generator for .NET and PowerShell</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature">
    <a href="https://www.codetinkerer.com/passwords/"><img src="assets/index/random-passwords.png"/></a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://www.codetinkerer.com/passwords/">Random Passwords</a></h4>
    <p>in-browser password generator built on <a href="https://www.npmjs.com/package/secure-random-password">secure-random-password</a></p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature">
    <a href="https://www.npmjs.com/package/secure-random-password"><img src="assets/index/secure-random-password.png"/></a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://www.npmjs.com/package/secure-random-password">secure-random-password</a></h4>
    <p>secure random password generator for the browser / Node.js</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature sh">
    <a href="https://github.com/mkropat/sh-realpath">
      <pre><code>$ source ./realpath.sh
$ realpath /proc/self
/proc/2772

$ cd /tmp
$ mkdir -p somedir/targetdir somedir/anotherdir
$ ln -s somedir somedirlink
$ ln -s somedir/anotherdir/../anotherlink somelink
$ ln -s targetdir/targetpath somedir/anotherlink
$ realpath .///somedirlink/././anotherdir/../../somelink
/tmp/somedir/targetdir/targetpath</code></pre>
    </a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://github.com/mkropat/sh-realpath">sh-realpath</a></h4>
    <p>a portable, pure shell implementation of realpath</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature sh">
    <a href="https://github.com/mkropat/sslfie">
      <pre><code>Usage: sslfie [OPTION]... DOMAIN [DOMAIN2]...

Generate a self-signed x.509 certificate for use with SSL/TLS.

Options:
  -o PATH -- output the cert to a file at PATH
  -k PATH -- output the key to a file at PATH
  -K PATH -- sign key at PATH (instead of generating a new one)
  -c CC   -- country code listed in the cert (default: XX)
  -s SIZE -- generate a key of size SIZE (default: 2048)
  -y N    -- expire cert after N years (default: 10)
  -p      -- prompt for cert values
  -r      -- output csr instead of signing a cert</code></pre>
    </a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://github.com/mkropat/sslfie">SSLfie</a></h4>
    <p>generate self-signed x.509 certificates for use with SSL/TLS</p>
  </div>
</div>

<div class="portfolio-entry">
  <div class="portfolio-feature">
    <a href="https://github.com/mkropat/TidyDesktopMonster"><img src="https://raw.githubusercontent.com/mkropat/TidyDesktopMonster/master/docs/logo.png"/></a>
  </div>
  <div class="portfolio-description">
    <h4><a href="https://github.com/mkropat/TidyDesktopMonster">Tidy Desktop Monster</a></h4>
    <p>prevent shortcuts from cluttering your Windows desktop ever again</p>
  </div>
</div>

</div>

### Other Projects

- [BetterWin32Errors](https://github.com/mkropat/BetterWin32Errors) — a better interface to the constants defined in winerror.h
- [jumpthere.vim](https://github.com/mkropat/vim-jumpthere) — lightweight project switcher for Vim
- [luks-mount](https://github.com/mkropat/luks-mount) — teach mount(8) to open LUKS containers
- [`shpy`](https://github.com/mkropat/shpy) — spies and stubs for shell unit testing
- [Snippets](snippets) — a selected list of code snippets I've published
- [standalone-dovecot-imap](https://github.com/mkropat/standalone-dovecot-imap) — keep a local IMAP mirror, painlessly
- [Talks](talks) — list of some talks I've given
- [uniformity.vim](https://github.com/mkropat/vim-uniformity) — convert indentation+whitespace across a project to be consistent
