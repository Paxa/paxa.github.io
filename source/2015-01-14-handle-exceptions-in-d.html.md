---
title: Handle exceptions in D
date: 2015-01-14 00:00 WIB
tags: D, exception, try-catch
---

Here's how to handle exceptions in D.

~~~d
try {
    throw new Exception("error message");
} catch (Exception error) {
    writefln("Error catched: %s", error.msg);
} finally {
    writefln("in finaly block");
}
~~~

`catch (Exception error)` will catch all exception of type `Exception` and child (inhereted) types.


### Error types structure

Here is a list of standart error types in D (not complete)

```
Throwable
  - Error
    - AssertError
    - FinalizeError
    - HiddenFuncError
    - InvalidMemoryOperationError
    - OutOfMemoryError
    - RangeError
    - SwitchError
  - Exception
    - ErrnoException
    - UnicodeException
    - FileException (std.file)
    - ProcessException (std.process)
    - RegexException (std.regex)
    - DateTimeException (std.datetime)
    - TimeException (core.time)
    - StdioException (std.stdio)
    - StringException (std.string)
    - AddressException, HostException, SocketException, ... (std.socket)
```

### Custom errors

```d
// Define custom exception class
class ArgumentError : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

// Throw custom class error
throw new ArgumentError("first argument array should be not empty");

// Catch custom error
try {
    someFunction([]);
} catch (ArgumentError error) {
    writeln("ERROR: ", error.msg);
    return 1;
}
```

We need to add `string file = __FILE__, size_t line = __LINE__` which will automatically add position where exception was thrown, without it stacktrace will show line number of `super(msg)`.


### More

`nothrow` functions can not throw any exceptions. It's made to indicate for developers who will use your function, also for better compiled code generation.

```d
ulong size() nothrow { return m_size; }

```


Read more:

* [http://ddili.org/ders/d.en/exceptions.html](http://ddili.org/ders/d.en/exceptions.html)
* [http://dlang.org/library/core/exception.html](http://dlang.org/library/core/exception.html)
