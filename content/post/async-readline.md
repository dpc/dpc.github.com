+++
date = "2014-09-15T21:38:16-07:00"
draft = false
title = "Asynchronous GNU Readline printing"
+++

Some while ago I've spend my time developing a [XMPP command line client](http://github.com/dpc/xmppconsole) which is using [strophe XMPP library](http://code.stanziq.com/strophe/)
to handle XMPP and [GNU Readline](http://tiswww.case.edu/php/chet/readline/rltop.html) for I/O.

The idea was to have a readline prompt at the bottom and yet be able to asynchronously print incoming messages above it - in the "log window".

It seems that many people were looking for solution already:

* [GNU Readline: how do clear the input line?](http://stackoverflow.com/questions/1512028/gnu-readline-how-do-clear-the-input-line)
* [Using GNU Readline; how can I add ncurses in the same program?](http://stackoverflow.com/questions/691652/using-gnu-readline-how-can-i-add-ncurses-in-the-same-program)

I haven't found any satisfying answer on the web so I'd like to present my own solution.

Basic idea is to use alternate (asynchronous) GNU Readline interface and on each new asynchronous print:

* save a copy of current line state
* clear both prompt and current line (content + position)
* force screen update
* print asynchronous event (followed by a newline)
* restore prompt and current line state
* force screen update

Simple it is, indeed and you can see [a working code](http://github.com/dpc/xmppconsole/blob/master/src/io.c) if you don't believe.

The only thing that I was unable to get is preventing putting the original confirmed readline buffer in "log window". As this is not a big deal for my requirements the complete and universal solution would be able to change what the user typed in the readline buffer just before it's getting scrolled up and becoming part of the "log window".

I hope someone will fine it useful, like I do.

Update:

Below is a patch by Denis Linvinus:

http://pastebin.com/SA87Lxqq

that he uses to get more "unrestricted log window with a prompt" for his project and wanted me to share with you too. Generally, I think it's a bit unclean because of using vt100 escape sequences so I'm not going to merge it, but if anyone finds it useful, it's good for everyone.
