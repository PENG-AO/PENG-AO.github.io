---
layout: post
title: Ncurses tutorial in swift (4)
sub-title: Window and border
tags: Ncurses Swift
---

# 1. Intro

So far we are able to handle user input, output, change colors which is almost the main features about ncurses. But the truth is that it is not the full power of Ncurses.
In this tutorial let's check out an awesome and interesting function of Ncurses: Window, and here's an example of my school project of a rsic-v simulator that using Ncurses as gui.

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial4-sample.gif"></div>

# 2. Create a window

In fact we have created a least one window unconsciously, that is `stdscr = initscr()`. Therefore we can judge a conclusion that all changes on the screen have to be conducted upon a certain 'screen' that initialized by Ncurses and the most basic one is the standard screen: `stdscr` which is so basic that we even do not need to care about it.

> In fact most of the functions we have used so far are macros based on `stdscr`: `addch(chtype)` $\to$ `waddch(stdscr,chtype)`

Let get to the point now, we basically use `WINDOW* newwin(Int32 height, Int32 width, Int32 row, Int32 col)` and refresh it with `wrefresh(WINDOW*)`.

```swift
initscr()

let win = newwin(4, 20, 1, 2)
waddstr(win, "Hello from a sub-window")

refresh()
wrefresh(win)

getch()
endwin()
```

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial4-pic1.png"></div>

It is noticeable that there is an invisible boundary around the characters that placing it exactly at $(\text{height}, \text{width}) = (1, 2)$. And moreover the sub-window breaks the string at 19th character since it is not long enough to display within 1 line.

> Tip: when programming try to be clear about the layer level of each window and do not mess is up.
> <div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial4-pic2.png"></div>

At the end of a sub-routine when a window will not be used any more, maybe it is a good habit to delete it with `delwin(WINDOW*)`. But just like how we use `free(void*)` in C programming language, this function did nothing but return the ownership of certain memory back to system **without removing existing data**. In our occasion, `delwin(WINDOW*)` did a similar job, delete without removing it from screen, hence do not use it as an eraser.

# 3. Details about window

To be more specific, what we actually see on the screen is neither `stdscr` nor any window that created be `newwin`, but the data from a certain buffer (let's call it the buffer). By calling `refresh()` we copy the data from `stdscr` to the buffer which means we want to display it.

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial4-pic3.png"></div>

> the function of `getch()` also has the effect of refreshing screen, therefore there is no need to write like `refresh(); getch()` and `wrefresh(win); wgetch(win)`, just `getch()` and `wgetch(win)` is fine.

At this time after calling `wrefresh(win1)`, the data from `win1` will overwrite certain parts of the buffer which looks like visually covering.

Therefore, even though `delwin` was called to delete a window, only memory block of `win1` was released, the data copied to the buffer remains until being overwrote again.

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial4-pic4.png"></div>

In addition, the actual function of clearing are `erase()`, `werase(WINDOW*)`, `clear()`, `clear(WINDOW*)`. And the difference between `erase` and `clear` are somehow subtle, if you are interested check this [site](https://lists.gnu.org/archive/html/bug-ncurses/2014-01/msg00007.html) for more information. Usually `clear` and `wclear(WINDOW*)` would be fine.

# 4. Box

As we mentioned before, the boundary of a sub-window is invisible, hence it is hard to notice without a line-break or something else, which will be inconvenient when creating a feasible gui. In this section let's talk about the function: `box(WINDOW* win, chtype verch, chtype horch)`, where `verch` and `horch` are substitutable to other characters.

```swift
initscr()

let win = newwin(4, 20, 1, 2)
box(win, UInt32(0), UInt32(0)) // box the border, 0 is the default value
waddstr(win, "Hello from a sub-window")

refresh()
wrefresh(win)

getch()
endwin()
```

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial4-pic5.png"></div>

It seems that there is a border around the sub-window, but incomplete. The reason of unexpected cover is that borders were drawn at (0, 0~max col), (max row, 0~max col), (0~max row, 0), (0~max row, max col), took over one row or column. In order to display the border completely, we may adjust the string a little, `mvwaddstr(win, 1, 1, "Hello from a sub-window")`.

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial4-pic6.png"></div>

But it is obvious that though we move the cursor to (1, 1), the left and right border remain covered. Here's a trick I personally prefer.

```swift
initscr()

let outer = newwin(4, 20, 1, 2)
let inner = newwin(2, 18, 2, 3)
box(outer, UInt32(0), UInt32(0)) // box the border
waddstr(inner, "Hello from a sub-window")

refresh()
wrefresh(outer)
wrefresh(inner)

getch()
endwin()
```

Introducing another sub-window, the outer one for things like border and inner one for the actual contents.

At the end of this section, let's have a glance at the core of `box`. According to the official document, `box(win, verch, horch)` is a shorthand for `wborder(win, verch, verch, horch, horch, 0, 0, 0, 0)`, which means programmers are able to change every parts of the border (left-vertical, right-vertical, top-horizontal, bottom-horizontal, top-left-corner, top-right-corner, bottom-left-corner, bottom-right-corner) as they like. Please check official document or sites from references for more information.

# 5. References

- [NCURSES Programming HOWTO](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)
- [ncurses tutorials - Casual Coder](https://youtube.com/playlist?list=PL2U2TQ__OrQ8jTf0_noNKtHMuYlyxQl4v)
