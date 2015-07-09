---
layout: post
title: "Escaping Column and Table and Names in MySQL (Part 1)"
date: 2015-07-08
tags: mysql validation
---

*[Skip to Part 2]({% post_url 2015-07-08-escaping-column-and-table-names-in-mysql-part2 %})
if you just want a drop-in escaping function.  Keep reading if you want to know
why you don't need one.*

Thanks to widespread adoption of ORMs, it's rare that I need to construct SQL
queries in code.  However, there's at least a couple situations where the need
still arises:

- I want to [perform some kind of advanced query that's not exposed via the ORM](https://technet.microsoft.com/en-us/library/ms190766)
- I'm working in a legacy codebase that does not offer an ORM

(The latter is how I came to visit the topic recently.)

The trick with constructing SQL queries is that user-input typically needs to
go somewhere in the query, and that means you need to protect yourself from
[SQL injection](https://www.owasp.org/index.php/SQL_Injection).

![little bobby tables](/assets/little-bobby-tables.png "Obligatory")

__Fun Fact__: SQL injection [has been known a known vulnerability since the
late 90s][sql-phrack] and yet [it still][sql-vuln-1] [seems][sql-vuln-2] [to
make][sql-vuln-3] [headlines][sql-vuln-4] in 2015.

Fortunately, the database connector has my back.  Even if I can't get an ORM
for what I need to do, I've never heard of a situation† where the database
connector doesn't support [parameterized queries][owasp-queries].

```csharp
var getAccount = new SqlCommand(
    "SELECT * FROM accounts WHERE name=@name",
    dbConn);
getAccount.Parameters.AddWithValue("name", "alice");
var account = getAccount.ExecuteReader();
```

*Example of parameterized queries with ADO.NET in C#*

As long as all user input goes through a query parameter before it makes it
into the SQL query, there's no way I can introduce an injection vulnerability.
And the great thing about query parameters is that they support pretty much any
query you'd want to create... except when they don't.

### When Parameterized Queries Aren't Enough

In programming, laziness is a virtue.  Let's say I'm creating the interface for
a list of accounts.  I want to let the user sort the list by account name,
creation date, street address, or any other column.  To support this, I could
write code like:

```csharp
var listAccountsSql = "SELECT * FROM accounts";
switch (userSortSelection) {
    case "id":   listAccountsSql += " ORDER BY id";
    case "name": listAccountsSql += " ORDER BY name";
    case "type": listAccountsSql += " ORDER BY type";
    // ...some more cases...
    default:
        throw new UnrecognizedColumn(userSortSelection);
}
return new SqlCommand(listAccountsSql, dbConn).ExecuteReader();
```

But look at that duplication!  No, a virtuous lazy programmer wants to write
something like this:

```csharp
var listAccounts = new SqlCommand(
    "SELECT * FROM accounts ORDER BY @sortColumn",
    dbConn);
listAccounts.Parameters.AddWithValue("sortColumn", userSortSelection);
var accounts = listAccounts.ExecuteReader();
```

Notice how we're trying to make `@sortColumn` a parameter of the `ORDER BY`
clause.  Unfortunately that doesn't work, because you can't inject column or
table names with query parameters.††

It's not just `ORDER BY` clauses that have this limitation.  Query parameters
don't support injecting any of following:

- `WHERE` clause columns to filter on
- What columns to `SELECT`
- The table name to query

### The Right Approach

Let's take another look at the user-sortable query:

```sql
SELECT * FROM accounts ORDER BY @sortColumn
```

How does the user select (or input) which column to sort by?  Chances are it
looks roughly something like this:

![Listing with sortable headers](/assets/table-header-example.png)

If that's the case, the UI layer already has knowledge of what the valid column
names are.  __There's no need to escape user input in any way when it can be
validated against a whitelist of all known good values.__

Assuming the list of columns is defined somewhere in the code:

```csharp
var accountsSortableCols = new string[] { /* list of column names */ };
```

Then protecting the query from all forms of injection is as simple as:

```csharp
if (!accountsSortableCols.Contains(userSortSelection)) {
    throw new UnrecognizedColumn(userSortSelection);
}
var listAccountsSql = string.Format("SELECT * FROM accounts ORDER BY `{0}`",
    userSortSelection);
var listAccounts = new SqlCommand(listAccountsSql, dbConn);
var accounts = listAccounts.ExecuteReader();
```

This is consistent with the advice from [The Unexpected SQL
Injection](http://www.webappsec.org/projects/articles/091007.txt):

> The actual problem of the query is [...] the fact that user-supplied input is
> used as a column name.  Example B shows a possible solution, where only a fixed
> number of options are allowed. [...]
>
> Note that the same applies for other identifiers and syntactic elements that a
> programmer may wish to dynamically copy from the input to a query, such as
> table names, column aliases, ASC/DESC keywords, etc.

*— Alexander Andonov (From the section, "Hi, what's your column name?")*

__A further word of warning__: a query safe from injection is not necessarily
safe.  If `accountsSortableCols` from the example contained a sensitive column,
such as `secretAnswer`, a clever attacker could deduce the value without ever
needing SQL injection.

### When The Right Approach Isn't Enough

Good code architecture includes splitting separate concerns into separate
layers.  The code that validates if user-input represents a valid column is
frequently several layers removed from the code that constructs the SQL query.

If you saw the following in a codebase, could you say there was a vulnerability?

```csharp
SqlDataReader ListAccounts(string userSortSelection) {
    var sql = string.Format("SELECT * FROM accounts ORDER BY `{0}`",
        userSortSelection);
    return new SqlCommand(sql, dbConn).ExecuteReader();
}
```

Maybe.  It depends on the context.  Is `userSortSelection` always validated
before `ListAccounts` is called?  Then no, that code isn't vulnerable.

The trouble with this kind of code is that even if it's provably-secure right
now, there's no practical way to verify that it remains so.  Who is going to
check all the callers of `ListAccounts` (and their callers) for correct
validation after every change is made?

The lazy programmer doesn't.  The lazy programmer __validates or escapes__ all
user input where it is injected into the query — even when user input is
already validated elsewhere — so she doesn't have to re-examine all calling
code to check for a vulnerability every time a change is made.

*[Continue on to part 2]({% post_url 2015-07-08-escaping-column-and-table-names-in-mysql-part2 %})
to learn how to write a function that escapes MySQL column and table names*

---

† Parameterized queries even work in VB6.  It's sad that I know that for a fact.

†† Not entirely true.  If you contort your query, [you can specify column names indirectly](http://stackoverflow.com/a/13846257/27581)

[owasp-queries]: https://www.owasp.org/index.php/Query_Parameterization_Cheat_Sheet
[sql-phrack]: http://www.phrack.org/issues/54/8.html#article
[sql-vuln-1]: http://www.tripwire.com/state-of-security/latest-security-news/one-million-wordpress-websites-vulnerable-to-sql-injection-attack/
[sql-vuln-2]: http://www.wordfence.com/blog/2015/03/woocommerce-sql-injection-vulnerability/
[sql-vuln-3]: http://thenextweb.com/insider/2015/05/28/indian-music-streaming-service-gaana-hacked-millions-of-users-details-exposed/
[sql-vuln-4]: http://www.thewhir.com/web-hosting-news/millions-wordpress-installations-risk-blind-sql-injection-popular-seo-plugin-yoast

