# Nicer adb shell + Jonathan Levin's (and more) tools

This is a wrapper script around `adb` that puts the user in a `bash` session with the `PATH` variable including `/data/local/tmp`.

https://user-images.githubusercontent.com/1655290/208040163-fadabf05-d378-4772-a12a-927a6a0afa3e.mp4
 
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
    - `out` and `s` - collect files or screenshots from within the shell to an
      output directory on the host

## Automatic `adb pull`

In the `bash` shell, running the command `out` will collect files into a special
directory in `/data/local/temp` that's continually `adb pull`'d onto the host
machine. `s` is a special case of `out` that takes and sends a screenshot.

If you set the env variable `ANDROID_AUTOPEN_FILES` then, on macOS only, the
pulled files will be automatically opened with a call to `open`.

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
