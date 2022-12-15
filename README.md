# Nicer adb shell + Jonathan Levine's (and more) tools

This is a wrapper script around `adb` that puts the user in a `bash` session with the `PATH` variable including `/data/local/tmp`.

Contents:

* [Jonathan Levine's Tools](http://newandroidbook.com/tools)
* Statically linked `bash`
* A `bashrc` file with extra helpers and configuration (like setting the `HISTFILE`)
* A collection of helper functions and aliases, such as:
    - `ip4` - print the device's IPv4 address, if one is available
    - `h` - a uniform wrapper around various hash programs, like md5 and sha

## Requirements

This tool requires:

* Docker (only to get static bash for aarch64)
* `wget` OR `curl`

## USAGE

```bash
./adb_bash.sh  # Copies a bunch of tools and puts you in a bash session
```
