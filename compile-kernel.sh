#!/bin/bash
set -e
WORKING_DIR=/usr/src
VERSION="4.19.2"
cd $WORKING_DIR
git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
cd linux-stable/
git checkout -b my_v${VERSION} v${VERSION}
cp /boot/config-`uname -r` .config
make olddefconfig
make -j`nproc`
sudo make -j`nproc` modules_install
sudo make install
