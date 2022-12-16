#!/bin/bash

set -e

# Already installed:
cp /bin/bash-static /target/

# Less we gotta build:
cd ~
wget http://www.greenwoodsoftware.com/less/less-608.tar.gz
tar xzf less-608.tar.gz
cd less-608
./configure LDFLAGS="-static"
make
cp less /target/less-static
