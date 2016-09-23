+++
date = "2016-09-15T21:38:16-07:00"
draft = false
title = "Precache all the things!"

+++

![funny meme](http://cdn.memegenerator.net/instances/400x/33671988.jpg)

Having a lot of RAM nowadays is relatively cheap and Linux can make a good use
of it. With tools like [preload][preload] most of Linux distributions are
trying to proactively read things that you might want to use soon.

[preload]: http://en.wikipedia.org/wiki/Preload_(software)

However if your desktop have a ridiculous amount of memory (mine has 32GB) it
may take ages for these tools to make use of all that memory. And why would you pay
for it and then let it just sit idle instead of working for you?

The thing is: you can do much better, because you know what you are going to
use in the future.

So, as always, let's write a tiny script under the name `precache`.

``` bash
#!/bin/sh

exec nice -n 20 ionice -c 3 find "${1:-.}" -xdev -type f \
	-exec nice -n 20 ionice -c 3 cat '{}' \; > /dev/null
```

Personally I keep it as `$HOME/bin/precache`.

<!--more-->

The basic idea is to traverse through all the subdirectories of an argument
using `find` and read all the files from the disk, discarding their output. If no
argument is given `precache` will traverse the current directory.

The `nice` and `ionice` commands are used to force all of this to be done only
when the system is really idle, so it's not slowing down anything else.

Keep in mind that the script will not switch to different filesystems (`-xdev`
option).

All of this is done to make Linux fill the free memory with cached
data so it's already waiting for you when you need it. You can check the
memory usage using `top` command. The `cached` position is the one that we want
to increase to the point where no memory is sitting idle.

How do I use this script? There are multiple ways.

First, you can preload your whole home directory on boot.

``` bash
#!/bin/sh

if [ ! -f "/tmp/$USER-home-precache" ]; then
	touch -f "/tmp/$USER-home-precache"
	precache "$HOME" &
fi
```

[Add this command to your autostart on login.][autostarting] or alternatively
just put:

	precache /home/<yourusername> &

in your system's `/etc/rc.local`.

[autostarting]: http://en.gentoo-wiki.com/wiki/Autostart_Programs

Also, when you're about to work on something in few minutes (like launching a
game or starting a big compilation), you can precache relevant directories to
make the game load and work faster.
