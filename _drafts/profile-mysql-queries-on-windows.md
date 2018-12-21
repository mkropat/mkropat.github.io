---
layout: post
title: "Profile (View All) MySQL Queries on Windows"
date: 2016-2-29
tags: mysql logging howto
---

For debugging purposes it can be useful to view all the SQL queries that are
being run against a MySQL instance.  This is doubly true any time you're using
an ORM.  This post is a quick howto to set this up on your local development
Windows machine.

<!--more-->

Before we begin, you need to know that there are two different (but
overlapping) query logs that MySQL supports:

1. The binary log — fast and space efficient, but only logs queries that write to a table
1. The general log — slow and verbose, but logs everything

The binary log exists (as far as I understand it) so that database changes can
be replicated to other MySQL instances.  It's a happy coincidence that it's
also a useful source for viewing a subset of queries that were run against the
database. I've included brief instructions at the bottom of the post for
viewing the binary log.

For debugging purposes, the more useful of the two is the general log.  So
that's where we'll begin...

### Enable General Logging

These instructions assume you are installing MySQL from the [chocolatey
package](https://chocolatey.org/packages/mysql):

    choco install mysql

The latest version of the Chocolatey package will create a default config
file.  Edit the file at: `%SYSTEMDRIVE%\tools\mysql\current\my.ini`

Under the `[mysqld]` section add a new line:

```
general_log=1
```

The default log location is at: `%PROGRAMDATA%\MySQL\data\%COMPUTERNAME%.log`

You can change the log file name and location with
[`general_log_file`](http://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_general_log_file).`

That's it.  Restart the MySQL service to have the change take effect.

__Note:__ Because general logging can introduce performance issues, it is
recommended that you disable general logging (`general_log=0`) when you're done
profiling your application.

### Tail the General Log

All queries are now being logged to `%PROGRAMDATA%\MySQL\data\%COMPUTERNAME%.log`.

I recommend using [TailBlazer](https://github.com/RolandPheasant/TailBlazer) to
both follow the log as MySQL writes to it and to search it.  Simply open
TailBlazer and drag the log file over the TailBlazer window.

![screenshot](FIXME)

### Enable Binary Logging

Edit the same `my.ini` file mentioned above.  Under the `[mysqld]` section add
two new lines:

```
server_id=1
log_bin=C:\\ProgramData\\MySQL\\mysql-bin
```

That's it.  Restart the MySQL service to have the change take effect.

### View the Binary Log

```
cd %PROGRAMDATA%\MySQL
mysqlbinlog mysql-bin.000099
```

(Replace `mysql-bin.000099` with whatever the latest log name is)

![screenshot](FIXME)
