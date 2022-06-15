---
layout: post
title: Ncurses tutorial in swift (1)
sub-title: Inputs
tags: Ncurses Swift
---

# 1. Intro

In most softwares, interaction is undoubtedly an essential part. For desktop softwares we may use mouse, for smart phone app we may just use the touch screen, for the one made by ncurses keyboard will be an intuitive choice.

# 2. Handle input

## 2.1 getch

Basically input handling in ncurses is nothing but the series of functions of `int getch(void)`. It takes no variables, then blocks the software and returns the ASCII number of input character, which is extremely handy in C programming language.

```c
while (getch() != 'q');
```

But in Swift, since character and string are not that exchangeable with integer, we have to use some snippet like this to retrieve the real value which matches the return value of `getch`.

```swift
while getch() != UnicodeScalar("q").value {}
```

Moreover, function keys like arrows and Fn etc. are defaulted to be inactive. Therefore in order to handle keys like 'arrow up', function `keypad(WINDOW*, bool)` is needed.

```swift
keypad(stdscr, true)
var c: Int32 = 0
repeat {
    c = getch()
    if c == KEY_UP {
        addstr("KEY_UP\n")
    }
} while c != UnicodeScalar("q").value
```

## 2.2 getstr

Besides `getch` there is `getstr` series as well. Instead of returning a string pointer, `getstr` takes a pre-allocated buffer, which is really troublesome for Swift. Here's a sample.

```swift
extension String {
    static func unsafeMutablePointer(len: Int) -> UnsafeMutablePointer<CChar> {
        let buffer = UnsafeMutableBufferPointer<CChar>.allocate(capacity: len)
        return buffer.baseAddress!
    }
}

while true {
    let input = String.unsafeMutablePointer(len: 16)
    getstr(input)
    if String(cString: input) != "quit" {
        addstr(input)
    } else {
        break
    }
}
```

More information of `getch` and `getstr` series will be mentioned in future tutorials.

# 3. Input mode

When executing the sample codes above, you might have probably noticed that there is a blinking cursor on the screen and all our inputs are visible (except for function keys). That would be fine when learning or debugging, but sometimes we may want to hide it or input without completely blocking. In this section, we are going to look at some functions that affects the input mode.

## 3.1 noecho and curs_set

Usually, `getch` is in echo mode initially, which means every charater user typed will be displayed on the screen. `int noecho(void)` is the very function to turn it off, or switch to noecho mode in other words. According to the official document, starting with `noecho` and turning it on whenever we actually want the echo mode is recommended. On the other hand, function `int curs_set(int visibility)` is prepared for changing the appearance of cursor.

|visibility|mode|
|:-:|:-:|
|0|invisible|
|1|normal|
|2|very visible|

## 3.2 raw and cbreak

To some extent, these 2 functions are alike. They both make the input characters pass through to the program without buffering. On the other side, they are somehow 'mutex' on treating special inputs like 'interupt', 'quit', 'suspend' etc.. `cbreak` allows actually sending signals but `raw` takes the original characters which is useful to prevent users from quitting program in an unexpected way.

## 3.3 halfdelay, nodelay and timeout

So far, all input functions block the program completely, user has to type something to get it over with. But sometimes when making a quiz app or a racing game, we want users to give back the answer within certain time limits, or just catch the current input immediately. `int halfdelay(int)` and `int nodelay(WINDOW*, bool)` will be the good choices. `halfdelay` waits for at most $\frac{t}{10}$ sec and returns `ERR` if there is no input and `nodelay(stdscr, TRUE)` realizes a non-blocking input.

# 4. References

- [NCURSES Programming HOWTO](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)
- [ncurses tutorials - Casual Coder](https://youtube.com/playlist?list=PL2U2TQ__OrQ8jTf0_noNKtHMuYlyxQl4v)
- [SwiftのStringからCの文字列を生成するベスト・プラクティス](https://qiita.com/ysn/items/83292f6226f8e5cd7bea)
