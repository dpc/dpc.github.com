+++
date = "2016-09-15T21:37:51-07:00"
draft = false
title =  "Shell tip: `retry.sh`"
tags = ["shell"]

+++

It's often the case when I have a command you want to retry until it's successful.

It's useful to have `retry.sh` script like this:

``` bash
#!/bin/sh

while ! "$@"; do sleep 1; done
```
