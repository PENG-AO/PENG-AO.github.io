---
layout: post
title: Ncurses tutorial in swift (3)
sub-title: Color and attributes
tags: Ncurses Swift
---

# 1. Intro

Besides moving cursor, changing color is a complicated task as well. Even though we have found the exact escape sequences to use, without some proper comments the code will be impossible to explain the next time we read it.
In this tutorial, we are going to cover the color usage in Ncurses, and some more interesting features.

# 2. Color

To be rigorous, let's check whether the current shell supports color.

```swift
guard has_colors() else { endwin(); exit(-1) }
```

> to make sure that we can change the definition of color, `bool can_change_color(void)` is recommended (`has_color` check included).

Then tell the shell that we are about to use colors and define some personal color pairs.

|color|value|
|:-:|:-:|
|COLOR_BLACK|0|
|COLOR_RED|1|
|COLOR_GREEN|2|
|COLOR_YELLOW|3|
|COLOR_BLUE|4|
|COLOR_MAGENTA|5|
|COLOR_CYAN|6|
|COLOR_WHITE|7|

```swift
start_color()
// color pair 0 is not revisable
init_pair(1, Int16(COLOR_MAGENTA), Int16(COLOR_WHITE))
```

And now turn on the color, print out some words.

```swift
attron(COLOR_PAIR(1))
addstr("Hello World!")
attroff(COLOR_PAIR(1))
```

> here is a point that should be careful with: `int init_pair(short pair, short foreground, short background)` takes short (Int16) as color variable, but color 'macro's are defined as Int32.

So far we have mastered the basic usage of color in Ncurses, which is so much simpler than escape sequences.

> `int init_color(short color, short r, short g, short b)` was skipped in this tutorial

# 3. More attributes

In a text-based content, not only colors but features like bold are important as well. Unfortunately we are not able to change font or make character italic with Ncurses, but we still have lots more methods to make characters look good by using the defined attributes bellow.

|macro|effect|shift|
|:-:|:-:|:-:|
|A_NORMAL|Normal display (no highlight)|A_NORMAL=0|
|A_STANDOUT|Best highlighting mode of the terminal|8|
|A_UNDERLINE|Underlining|9|
|A_REVERSE|Reverse foreground and background color|10|
|A_BLINK|Blinking|11|
|A_BOLD|Extra bright or bold|13|
|...|...|...|

```swift
// only A_NORMAL was defined in ncurses of swift
let ATTRIBUTE_SHIFT = 8
let BITS: (Int, Int) -> Int32 = { Int32($0) << ($1 + ATTRIBUTE_SHIFT) }
let A_REVERSE = BITS(1, 10)

start_color()
init_pair(1, Int16(COLOR_YELLOW), Int16(COLOR_BLACK))
let emphasis = A_REVERSE | COLOR_PAIR(1)
attron(emphasis)
mvaddstr(5, 5, "abc")
attroff(emphasis)
```

<div class="img-frame"><img src="/assets/src/a-tutorial-of-ncurses-in-swift/tutorial3-pic1.png"></div>

As you might have already noticed, the value of color pair was nothing but a `Int32` which `attron` takes as variable. The truth is that both color pair and macros like A_NORMAL work as a bit mask, they extend the information that a character takes, make a character of type `char` into a new one `chtype` (UInt32).

$$
\text{chtype} := \text{attribute (31:8) | char (7:0)}
$$

Therefore, when printing a single character we could use the codes below to skip `attron` and `attroff`.

```swift
let c = UnicodeScalar("@").value | UInt32(A_REVERSE | COLOR_PAIR(1))
mvaddch(7, 5, c)
```

# 4. chgat

At the end of this tutorial, let's have a little bit level up. Supposing that there are some contents on the screen and we do not possess its value, `int chgat(int n, attr_t attr, short color, NULL)` will be helpful if we want to change its attributes and even without advancing the cursor position.

> A character count (n) of -1 or greater than the remaining window width means to change attributes all the way to the end of the current line. (man chgat)

```swift
let ATTRIBUTE_SHIFT = 8
let BITS: (Int, Int) -> Int32 = { Int32($0) << ($1 + ATTRIBUTE_SHIFT) }
let A_NORMAL = Int32(0)
let A_STANDOUT = BITS(1, 8)
let A_REVERSE = BITS(1, 10)
let NULL = "".unsafePointer

start_color()
init_pair(1, Int16(COLOR_WHITE), Int16(COLOR_BLUE))
mvaddstr(0, 5, "Hello world!") // cursor at the end of "hello world!"

getch()
// hello in foreground black and background white
mvchgat(0, 5, 5, UInt32(A_STANDOUT), 0, NULL)

getch()
// world in foreground blue and background white
mvchgat(0, 11, 5, UInt32(A_REVERSE), 1, NULL)

getch()
// every thing back to normal
mvchgat(0, 0, -1, UInt32(A_NORMAL), 0, NULL)
```

> `int attrset(int attrs)` was skipped in this tutorial

# 5. References

- [NCURSES Programming HOWTO](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)
- [ncurses tutorials - Casual Coder](https://youtube.com/playlist?list=PL2U2TQ__OrQ8jTf0_noNKtHMuYlyxQl4v)

