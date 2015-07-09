---
layout: post
title: "Escaping Column and Table and Names in MySQL (Part 2)"
date: 2015-07-08
tags: mysql validation
---

*[Check out part 1]({% post_url 2015-07-08-escaping-column-and-table-names-in-mysql-part1 %})
to learn why you don't actually need an escaping function.*

So you want a function to escape or validate user-input that is going to be
inserted into a MySQL query as a column or table name?

To get more concerte, let's imagine a hypothetical usage:

```csharp
var sql = string.Format("SELECT * FROM accounts ORDER BY {0}",
    QuoteMysqlSchemaName(userSortSelection));
return new SqlCommand(sql, dbConn).ExecuteReader();
```

*Everything's going to be in C# from here on out btw, but the lessons should
apply for any language.*

How do we write the `QuoteMysqlSchemaName` function so that — no matter what
value `userSortSelection` may be — there's no way unintended SQL injection can
occur?

### What Needs To Be Escaped?

First things first: the escaping function needs to surround the name in
backtick `` ` `` quotes.  But that's just good programming practice, because
without quotes even the most basic cases (spaces, reserved keywords) will break
the query.

The next case to handle is to __escape any backtick `` ` `` quotes in the
user-input__, which MySQL would otherwise confuse with the name's end quote.
The MySQL documentation [describes the escaping
mechanism](https://dev.mysql.com/doc/refman/5.7/en/identifiers.htm):

> Identifier quote characters can be included within an identifier if you quote
> the identifier. If the character to be included within the identifier is the
> same as that used to quote the identifier itself, then you need to double the
> character.

Translated into code:

```csharp
var escaped = name.Replace("`", "``");
```

Believe it or not that's all that needs to be *escaped*, but we're not done
yet...

### What Characters Are Prohibited?

Some characters are valid in names, there's the backtick which is valid when
escaped, and there are some characters that aren't valid at all.  [The
documentation lists the full
rules](http://dev.mysql.com/doc/refman/5.7/en/identifiers.html):

> - Permitted characters in quoted identifiers include the full Unicode Basic Multilingual Plane (BMP), except U+0000:
>   - ASCII: U+0001 .. U+007F
>   - Extended: U+0080 .. U+FFFF
> - ASCII NUL (U+0000) and supplementary characters (U+10000 and higher) are not permitted in quoted or unquoted identifiers.
> - Identifiers may begin with a digit but unless quoted may not consist solely of digits.
> - Database, table, and column names cannot end with space characters.

In addition, [earlier versions of MySQL had more restrictive
rules](https://dev.mysql.com/doc/refman/5.0/en/identifiers.html):

> - Before MySQL 5.1.6, database and table names cannot contain “/”, “\”, “.”,
>   or characters that are not permitted in file names.

Since old databases have a tendency to stick around, any escaping function that
claims to be general use probably needs to check for the more conservative
restricitons.

An additional concern with the "." character specifically is that it sometimes
has a special meaning in names.  Imagine you saw the code: `SELECT * FROM
foo.bar`.  Is that referring to a table named `foo.bar` or a table `bar` in the
database `foo`?

I've never seen a case where MySQL treats a quoted name like `` `foo.bar` `` as
anything other than the name of a specific table or column, so prohibiting "."
might not be strictly necessary.  I'd rather play it safe though.

If the escaping function __encounters any of these prohibited characters__, the
only thing it can do is __throw an exception at that point__.

That's everything the escaping function needs to handle as far as individual
characters.  However, there are a few other considerations...

### SQL Truncation Vulnerability

[The max size of a column name or a table name in MySQL is 64
characters](http://dev.mysql.com/doc/refman/5.7/en/identifiers.html).  If you
were to store a *quoted* column or table name in a MySQL variable, it would
need to be 66 character long (64 for the identifier + 2 characters for the
outside quotes).

There's an uncommon SQL vunlernability that can occur when a quoted name that's
longer than 66 charactes is injected into a MySQL statement (such as a `CALL`
to a stored procedure) that ends up being assigned to a variable that's only 66
characters long.†

Not matter how unlikely, since the max column and table name length is defined,
it's trivial to protect against — __throw an error if the caller tries to quote
a column or table name that's longer than 64 characters__.

### Aside: Escape Function Contract Best Practices

There's an anti-pattern I've seen in most of the homegrown escaping libraries
I've worked with.  If the library offers a function `EscapeSqlSchemaName`,  you are
expected to use it like this:

```csharp
var getCustomerSql = "SELECT * FROM accounts ORDER BY `" +
    EscapeSqlSchemaName(sortColumn) + "`";
var accounts = new SqlCommand(getCustomerSql, dbConn).ExecuteReader();
```

Notice how the <code>`</code> characters are added by the caller — not by the
escaping function.  Compare this with how the hypothetical column-name query
parameter from before worked:

```csharp
var listAccounts = new SqlCommand(
    "SELECT * FROM accounts ORDER BY @sortColumn",
    dbConn);
listAccounts.Parameters.AddWithValue("sortColumn", userSortSelection);
var accounts = listAccounts.ExecuteReader();
```

We expect the query parameter to add the necessary `` ` `` quote
characters.  Not only does this remove duplication from all the calling code,
__it also avoids a potential SQL injection vulnerability__.

Imagine the caller expects `EscapeSqlSchemaName` to protect them and the caller
happens to have set
[`ANSI_QUOTES`](https://dev.mysql.com/doc/refman/5.7/en/sql-mode.html#sqlmode_ansi_quotes):

```csharp
var getCustomerSql = "SELECT * FROM accounts ORDER BY \"" +
    EscapeSqlSchemaName(sortColumn) + "\"";
var accounts = new SqlCommand(getCustomerSql, dbConn).ExecuteReader();
```

The `EscapeSqlSchemaName` function expects the caller to use the `` ` ``
character to escape names, but the caller is using `"` (which is valid when
`ANSI_QUOTES` is set).  The `sortColumn` parameter is now vulnerable to [blind
SQL injection](https://www.owasp.org/index.php/Blind_SQL_Injection) with
something like:

    id",IF((SELECT 1 FROM users WHERE username=0x626f62 AND
        password=0x70617373),id,name)--"

To avoid [a silly mismatch between what the caller expects and what the
function does](http://www.cnn.com/TECH/space/9909/30/mars.metric/), __it is
best that the function that does the escaping also adds any necessary quote
characters__.  To that end, instead of calling the function
`EscapeSqlSchemaName`, I prefer to call it something like
`ConvertSqlSchemaName` or `QuoteSqlSchemaName`.

### General Schema Name Escaping

We have a pretty good idea now of (hopefully) all the possible things that
aren't allowed in a name.  The implementation follows naturally:

```csharp
string QuoteMysqlSchemaName(string name)
{
    if (string.IsNullOrEmpty(name))
        throw new ArgumentException("name must have a value");

    const int maxLength = 64;
    if (name.Length > maxLength)
        throw new ArgumentException(string.Format("name is longer than {0} characters", maxLength));

    var prohibited = new [] { '\0', '.', '/', '\\' };
    foreach (var c in name) {
        if (prohibited.Contains(c))
            throw new ArgumentException("name may not contain: '.', '/', or '\\'");

        if (char.IsHighSurrogate(c) || char.IsLowSurrogate(c))
            throw new ArgumentException("name may not contain unicode supplementary characters");
    }

    if (name.EndsWith(" "))
        throw new ArgumentException("name may not end with a space");

    return "`" + name.Replace("`", "``") + "`";
}
```

I have every reason to believe that this implementation will protect the caller
from all SQL injection vulnerabilities.

And yet... that's not how I implemented the function in the codebase I was
working on.

### Alternate Implementation: Character Whitelist

The problem with security vulnerabilities is that what you don't know *can hurt
you*.

In the codebase I was working on it was convenient that all the table and
column names consisted of alphanumeric and/or underscore characters.  As those
characters are inherently safe from escaping out of schema name `` ` `` quotes
`` ` ``, I chose to opt for a more conservative solution:

```csharp
string QuoteMysqlSchemaName(string name)
{
    if (string.IsNullOrEmpty(name))
        throw new ArgumentException("name must have a value");

    const int maxLength = 64;
    if (name.Length > maxLength)
        throw new ArgumentException(string.Format("name is longer than {0} characters", maxLength));

    var characterWhitelist = new Regex("^(?![0-9])[A-Za-z0-9_]*$");

    if (!characterWhitelist.IsMatch(name))
        throw new ArgumentException("name may contain only alphanumerics or underscores, and may not begin with a digit");

    return "`" + name + "`";
}
```

(Notice that names that begin with a digit are explicitly forbidden because
[the documentation warns against
it](https://dev.mysql.com/doc/refman/5.7/en/identifiers.html) in certain
situations.)

If the requirements permit it, a whitelist solution beats an
escape-all-the-bad-things solution every time.  A whitelist of valid names is
best, but a whitelist of valid characters works too.

Having said all that, if my requirements were not so simple, I would not
hesitate to use the general `QuoteMysqlSchemaName` function from the previous
section.  What you choose to do is up to you.

---

† Perhaps it's also the responsibility of the stored proedure that uses
[PREPARE statement](https://dev.mysql.com/doc/refman/5.7/en/prepare.html) to
protect against truncation attacks, but I wouldn't rely on it.
