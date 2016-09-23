+++
date = "2016-01-15T21:37:51-07:00"
draft = false
title =  "Prepend or append to PATH like environment variable."
+++

In Unix there are quite a lot variables representing path lists of different kind similar to `PATH` like `LD_LIBRARY_PATH`, `PKG_CONFIG_PATH`.

Usual idiom to modify these variables is:

    $PATH="$PATH:/new/path/to/something"

I found it quite a lot of typing in a daily work, so I'm using functions shortening the above to just:

    append_env PATH /new/path/to/something

The version for Bash is:

    function append_env {
        if [ -z "${!1}" ]; then
            export "$1"="$2"
        else
            export "$1"="${!1}:$2"
        fi
    }
    function prepend_env {
        if [ -z "${!1}" ]; then
            export "$1"="$2"
        else
            export "$1"="$2:${!1}"
        fi
    }


And for Zsh:

    function append_env {
        eval "local v=\$$1"
        if [ -z "$v" ]; then
            export "$1"="$2"
        else
            export "$1"="$v:$2"
        fi
    }
    function prepend_env {
        eval "local v=\$$1"
        if [ -z "$v" ]; then
            export "$1"="$2"
        else
            export "$1"="$2:$v"
        fi
    }
