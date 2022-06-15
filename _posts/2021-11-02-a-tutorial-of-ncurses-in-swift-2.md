---
layout: post
title: Ncurses tutorial in swift (2)
sub-title: Move and print
tags: Ncurses Swift
---

# 1. Intro

Basing on the user input of previous tutorial, let's talk about output this time.
Speaking of output, assuming that we have already had some contents for output, then 'where' and 'how' are 2 inevitable problems to cope with. When using `printf` in C or `print` in python to print out to stdout, we seldom consider 'where' since contents are consecutively taking up each line and hardly could we go back again, which is also the difficulty of making UI just with `print`. But all problems will be solved easily in Ncurses.

# 2. Where to print

With the help of escape sequences like '\033[<L>;<C>H' (bash) it is possible to move the cursor as wished, but thanks to Ncurses a simple function `int move(int y, int x)` (C) packed all complexities. Supposing the right-top corner to be the origin point of (0, 0), y grows downwards and x grows rightwards. If y and x are a little bit implicit for you, then just take y as row and x as column.

> parameter type like `int` of C must be declared explicitly as `Int32` in Swift

```swift
var i: Int32 = 0
while getch() != UnicodeScalar("q").value {
    move(i, i)
    i += 1
}
```

By executing the codes above, you will find out that the position of user input moves on diagonal.

# 3. How to print

There are 2 series of print functions in Ncurses as we mentioned in tutorial 0, `printw` and `addstr`. For the reason of variable arguments, `printw` series is not recommended personally.

> though I did not worked out, `CVarArg`, `getVaList` might be helpful for someone who is interested

Anyway, the main purpose of using `printw` in C is to build the output string dynamically, since Swift has supported such feature for String type, there is no need for us to stick at `printw`. Here's a simple example.

```swift
let row: Int32 = 10, col: Int32 = 10
move(row, col)
let author = "PENG AO"
addstr("Hello world! from \(author) at (\(row), \(col))")
```

Furthermore, there are some more combined functions from the considerate Ncurses, and we may rewrite the program in the following way.

```swift
let row: Int32 = 10, col: Int32 = 10
move(row, col)
let author = "PENG AO"
mvaddstr(row, col, "Hello world! from \(author) at (\(row), \(col))")
```

# 4. References

- [NCURSES Programming HOWTO](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)
- [ncurses tutorials - Casual Coder](https://youtube.com/playlist?list=PL2U2TQ__OrQ8jTf0_noNKtHMuYlyxQl4v)
