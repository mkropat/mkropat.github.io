---
layout: page
permalink: /snippets
title: Snippets
secondary: true
---

This is a curated list of potentially useful snippets that I've published.

<h4>C#</h4>

- [ArtificialStackTraceException.cs](https://gist.github.com/mkropat/afc501468d669c97f027b52c3adc10b5) — when you need a stack trace but you don't need to `throw`
- [KeyValueConfigStore.cs](https://gist.github.com/mkropat/abf0f1235f0c76034733) — simple windows registry interface
- [MicroLog.cs](https://gist.github.com/mkropat/efa2b76272f900774f27) — C# logging micro-framework
- [Migrate-Db.ps1](https://gist.github.com/mkropat/1ba7ffd1d14f55f63fb3) — run schema migration scripts on a SQL Server databse
- [NanoLog.cs](https://gist.github.com/mkropat/8111690ee4b6fce62620) — C# logging nano-framework

#### Javascript

- [require.js](https://gist.github.com/mkropat/c25ef5fc57d75a042868e6a160c175cf) — `require(...)` npm dependencies from the browser console
- [ui-router-logging.js](https://gist.github.com/mkropat/6de4e1dc3a9577789917) — automatic trace logging of Angular.js events and ui-router state transitions

#### *nix

- [csv2json](https://gist.github.com/mkropat/1fdde16aafe3b769bd1b) — convert `.csv` files into `.json` files
- [mkgitconfig](https://gist.github.com/mkropat/473c5515477e2eb7e008) — sensible Git defaults
- [tun0](https://gist.github.com/mkropat/5b3031fbc35f464ebea8) — openVPN integration with `interfaces(5)`

#### PowerShell

- [EnvPaths.psm1](https://gist.github.com/mkropat/c1226e0cc2ca941b23a9) — functions for manipulating `$env:PATH`
- [Get-WebFile.ps1](https://gist.github.com/mkropat/16c5cf675faf29140e76ca72f0b4c0cf) — download a file and verify its integrity

#### Python

- [getuser.py](https://gist.github.com/mkropat/7559409) — lookup user id and name from the source (read: no environmental variables consulted). Cross-platform compatible (Windows, *nix).
- [knownpaths.py](https://gist.github.com/mkropat/7550097) — Python wrapper around the `SHGetKnownFolderPath` Windows Shell function

#### Windows

- [autoupdate.bat](https://gist.github.com/mkropat/d0f6135d1e754a16b980) — hands-off script to fully patch a fresh Windows install
- [delete-temp-aspnet.ps1](https://gist.github.com/mkropat/8eaf13fb3dc76f4b7626) — delete all files in `Temporary ASP.NET Files` at boot
- [DeleteQueue.bat](https://gist.github.com/mkropat/8d385f15936876ac151d) — fast-delete the files in the delete queue
- [Get-AssemblyReverseReferences.ps1](https://gist.github.com/mkropat/fa8b03dbcff8b9184b20) — what .dll's are referencing this .dll (and which version)?
- [Get-WindowsSDKConstant.ps1](https://gist.github.com/mkropat/d8b744c994eaa59493648f8795d9dde8) — calculate the value for any constant in the Windows SDK
- [maintain-links.ps1](https://gist.github.com/mkropat/fa0bc9179c0610b84543) — automatically maintain shortcuts to files in subdirectories
- [measure-lines.ps1](https://gist.github.com/mkropat/c7741d92fb3ab580f332) — find files with the most lines of code in a project
