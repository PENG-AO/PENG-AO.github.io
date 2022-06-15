---
layout: post
title: Ncurses tutorial in swift (5)
sub-title: Summary / Something left
tags: Ncurses Swift
---

# 1. Intro

In this tutorial, let me list something that were not covered in the previous tutorial or covered inexplicitly, without explaining. Or just consider this as a summary of Ncurses functions. (specified for swift)

# 2. Recommended extension

```swift
extension String {
    var unsafePointer: UnsafePointer<CChar> {
        self.withCString {
            UnsafePointer<CChar>($0)
        }
    }

    static func unsafeMutablePointer(len: Int) -> UnsafeMutablePointer<CChar> {
        let buffer = UnsafeMutableBufferPointer<CChar>.allocate(capacity: len)
        return buffer.baseAddress!
    }
}

let ATTRIBUTE_SHIFT = 8
let BITS: (Int, Int) -> Int32 = { Int32($0) << ($1 + ATTRIBUTE_SHIFT) }
let CTRL: (Character) -> Int32 = { Int32($0.asciiValue!) & 0x1F }
let A_NORMAL = Int32(0)
let A_STANDOUT = BITS(1, 8)
let A_REVERSE = BITS(1, 10)
let NULL = "".unsafePointer
```

# 2. Init, deinit, fresh, clear

- `initscr() -> WINDOW*`
- `endwin()`
- `refresh()`
- `clear()`, `erase()`
- `clrtobot()`, `clrtoeol()`: clear to bottom, clear to end of line

# 3. Input and output

- `getch() -> Int32`
- `getstr(UnsafeMutablePointer<CChar>!)`
- `addch(chtype)`
- `addstr(string)`
- `cbreak()`, `raw()`, `noecho()`, `keypad(WINDOW*, Bool)`
- `halfdelay(Int32 t/10s)`, `timeout(Int32)`

# 4. Colors and attributes

- `has_colors() -> Bool`
- `start_color()`
- `init_color(Int16 colorIdx, Int16 r, Int16 g, Int16 b)`
- `init_pair(Int16 pairIdx, Int16 fgColor1, Int16 bgColor2)`
- `attron(Int32)`, `attrset(Int32)`, `attroff(Int32)`
- `chgat(Int32 length, attr_t, Int16 color, NULL)`

# 5. Move

- `move(Int32 y, Int32 x)`

## 5.1 combine with other functions

- `mvgetch(Int32 y, Int32 x)`
- `mvgetstr(Int32 y, Int32 x, UnsafeMutablePointer<CChar>!)`
- `mvaddch(Int32 y, Int32 x, chtype)`
- `mvaddstr(Int32 y, Int32 x, string)`
- `mvchgat(Int32 y, Int32 x, Int32 length, attr_t, Int16 color, NULL)`
- ...

# 6. Window and border

- `border(chtype ls, chtype rs, chtype ts, chtype bs, chtype tl, chtype tr, chtype bl, chtype br)`
- `hline(chtype, Int32 length)`, `vline(chtype, Int32 length)`
- `newwin(Int32 rows, Int32 cols, Int32 y, Int32 x)`
- `delwin(WINDOW*)`
- `box(WINDOW*, chtype verch, chtype horch)`

## 6.1 combine with other functions

- `wrefresh(WINDOW*)`
- `wclear(WINDOW*)`, `werase(WINDOW*)`
- `wgetch(WINDOW*) -> Int32`
- `wgetstr(WINDOW*, UnsafeMutablePointer<CChar>!)`
- `waddch(WINDOW*, chtype)`
- `waddstr(WINDOW*, string)`
- `wattron(WINDOW*, Int32)`, `wattrset(WINDOW*, Int32)`, `wattroff(WINDOW*, Int32)`
- `wchgat(WINDOW*, Int32 length, attr_t, Int16 color, NULL)`
- `wborder(...)`
- `whline(WINDOW*, chtype, Int32 length)`, `wvline(WINDOW*, chtype, Int32 length)`
- ...

## 6.2 combine with move series

- `mvwgetch(WINDOW*, Int32 y, Int32 x) -> Int32`
- `mvwgetstr(WINDOW*, Int32 y, Int32 x, UnsafeMutablePointer<CChar>!)`
- `mvwaddch(WINDOW*, Int32 y, Int32 x, chtype)`
- `mvwaddstr(WINDOW*, Int32 y, Int32 x, string)`
- `mvwchgat(WINDOW*, Int32 y, Int32 x, Int32 length, attr_t, Int16 color, NULL)`
- `mvwhline(WINDOW*, Int32 y, Int32 x, chtype, Int32 length)`
- `mvwvline(WINDOW*, Int32 y, Int32 x, chtype, Int32 length)`
- ...

# 7. Miscellaneous

- `curs_set(Int32)`
- `getmaxx(WINDOOW*)`, `getmaxy(WINDOW*)`
