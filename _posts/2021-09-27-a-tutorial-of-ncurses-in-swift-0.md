---
layout: post
title: Ncurses tutorial in swift (0)
sub-title: Hello World
tags: Ncurses Swift
---

# 1. What is ncurses?

Curses is a pun on "cursor optimization", by which developer may build their text-based GUI software that running on a terminal simulator easily, otherwise it is inevitable to engage with the complicated "escape sequences" which just like curses.

And ncurses is a freely distributable library that fully compatible with curses.

# 2. Why ncurses?

- For fun
- Having a lower perspective of UI design
- ...

# 3. Hello World

Firstly, in order to utilize ncurses in a Swift program, we have to `import Darwin.ncurses`.

Then, all ncurses program should begin with `initscr` and end with `endwin`. 
initscr implies that from now on terminal will be switched to "curses mode". During such mode, we must avoid using functions like print which might possibly pollute stdout. At the end of the program, using endwin function to stop the mode properly, otherwise the terminal will act oddly.

In a program written with C/C++, both `printw` class of functions and `addstr` class of functions are prepared for outputting. But in a Swift program, the printw class could be extremely hard to use for the reason of pointer. On the contrary, the convenience of replacement of string that provided by printw could be solved easily with utilizing the string replacement feature of Swift programming language.

Finally, here comes the code.

```swift
import Darwin.ncurses

initscr()

addstr("Hello world!") // add the given string to so-called buffer
refresh() // print the string on the real screen

getch() // wait for a user input
endwin()
```

# 4. Compile

Basically it is possible to compile a project that included ncurses just like how we do with C/C++ programming language.

## 4.1 XCode

.xcodeproj -> Build Phases

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial0-build-with-xcode-0.png"></div>

search "ncurses" -> click "Add"

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial0-build-with-xcode-1.png"></div>

## 4.2 Makefile

```makefile
src = # filename

main: $(src)
    swiftc -lncurses $^ -o $@

.PHONY: clean
clean:
    rm -f main
```

Here is a little tip, since there is no `main` function in swift, when compiling a project with multiple files, the "entrance" should be named with `main.swift`.

And I personally prefer using Makefile.

---

```shell
swiftc -lncurses 0-HelloWorld.swift -o main
./main
```

If nothing unexpected happens, there will be "Hello world!" on the corner of the screen.

# 5. References

- [NCURSES Programming HOWTO](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)
- [ncurses tutorials - Casual Coder](https://youtube.com/playlist?list=PL2U2TQ__OrQ8jTf0_noNKtHMuYlyxQl4v)
- [curses による端末制御](https://www.kushiro-ct.ac.jp/yanagawa/ex-2017/2-game/01.html)
