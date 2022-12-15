# Nicer adb shell + Jonathan Levin's (and more) tools

This is a wrapper script around `adb` that puts the user in a `bash` session with the `PATH` variable including `/data/local/tmp`.

**Important: the tools `jtrace64`, `bdsm`, `imjtool`, `memento` and `procexp`
are downloaded from nightly build archives and may be unstable.**

Contents:

* Automatically downloads *nighly builds* of [Jonathan Levin's
  Tools](http://newandroidbook.com/tools)
* Automatically downloads a statically linked `bash` (thanks, Ubuntu!)
* A `bashrc` file with extra helpers and configuration (like setting the
  `HISTFILE`)
* A collection of helper functions and aliases, such as:
    - `ip4` - print the device's IPv4 address, if one is available
    - `h` - a uniform wrapper around various hash programs, like md5 and sha
    - `strip_control` - removes control characters from input
    - `f` - opinionated `find` shorthand

## Requirements

This tool requires:

* Docker (only to get static bash for aarch64)
* `wget` OR `curl`

## USAGE

Clone or download this repository, `cd` into it and then run `./adb_bash.sh`.

## I have multiple devices and...

I gotcha - set `ANDROID_SERIAL` or pass the serial you want to use to the script as the first argument.

## Waaa! It takes a long time to download all the dependencies!

Only the first time, fam.
