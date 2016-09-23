#!/bin/sh

exec git subtree pull --prefix=public git@github.com:dpc/dpc.github.io.git master --squash
