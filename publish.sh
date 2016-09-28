#!/bin/sh

hugo

exec git subtree push  --prefix=public git@github.com:dpc/dpc.github.io.git master
