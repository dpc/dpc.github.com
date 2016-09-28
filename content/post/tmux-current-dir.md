+++
date = "2016-09-15T21:38:06-07:00"
draft = false
title = "Make current dir a tmux session placeholder."
tags = ["shell", "tmux"]

+++

` tmux-session.sh`:


``` bash 
#!/bin/bash
# Reattach to (or spawn new if not existing) tmux session
# tmux session <session_name> [ <session_directory> ]

export STY="tmux-$1"
RC=".tmux"
if [ ! -z "$2" ]; then
	RC="$2/$RC"
fi

RC="$(readlink -f "$RC")"

if ! tmux has-session -t "$1" 2>/dev/null ; then
	if [ ! -z "$RC" -a -f "$RC" ] ; then
		tmux new-session -d -s "$1" "tmux move-window -t 9; exec tmux source-file \"$RC\""
	else
		tmux new-session -d -s "$1"
	fi
fi

exec tmux attach-session -t "$1"
```


` tmux-here.sh`:

``` bash
#!/bin/bash
# Spawn tmux session in current directory
# use path's sha256 hash as session name

exec "$HOME/bin/tmux-session" "$(echo "$PWD" | sha256sum | awk '{ print $1 }')" "$PWD"
```
