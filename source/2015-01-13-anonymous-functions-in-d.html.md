---
title: Anonymous functions in D
date: 2015-01-13 00:00 WIB
tags: D, delegate, lambda, closure, function
---


We can use anonymous functions in [D](http://dlang.org/).

## `delegate`  keyword

Example with argument:

```d
import std.stdio;

void evenNumbers(int[] numbers, void delegate(int) callback) {
    foreach (int number; numbers) {
        if (number % 2 == 0) callback(number);
    }
}

void main() {
    auto numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    evenNumbers(numbers, (num) => writeln(num));
    // or numbers.evenNumbers((num) => writeln(num));
    // or numbers.evenNumbers((num) { writeln(num); });
}
```

In this case `(num) => writeln(num)` is an argument, callable function.

Output:

```
% rdmd delegate.d
2
4
6
8
10
```

-READMORE-

Alternative syntax, ruby's blocks style:

```d
import std.stdio, std.string, std.file, std.path;

void withingDir(string dir, void delegate() callback) {
    auto cwd = absolutePath(".").chomp(".");
    writeln("Current directory is: ", cwd);
    chdir(dir);
    callback();
    chdir(cwd);
}

void main() {
    withingDir("/var", {
        writefln("I'm in %s", absolutePath(".").chomp("."));
    });
}
```

Output:

```
% rdmd delegate.d
Current directory is: /Users/pavel/d-try/
I'm in /private/var/
```

If I want to have more rubish syntax I can make like this:

```d
alias void delegate() Block;

void withingDir(string dir, Block callback) {
    ...
}

```

## `function` keyword.

I don't know what is a difference between `delegate` and `function`, they doing same job.

Example one:

```d
import std.stdio;

void evenNumbers(int[] numbers, void function(int) callback) {
    foreach (int number; numbers) {
        if (number % 2 == 0) callback(number);
    }
}

void main() {
    auto numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    numbers.evenNumbers(function (num) {
        writeln(num);
    });
}
```

Example two:

```d
import std.stdio, std.string, std.file, std.path;

void withingDir(string dir, void function() callback) {
    auto cwd = absolutePath(".").chomp(".");
    writeln("Current directory is: ", cwd);
    chdir(dir);
    callback();
    chdir(cwd);
}

void main() {
    withingDir("/var", function () {
        writefln("I'm in %s", absolutePath(".").chomp("."));
    });
    // or withingDir("/var", { ... });
}
```


Read more:

* [http://ddili.org/ders/d.en/lambda.html](http://ddili.org/ders/d.en/lambda.html)