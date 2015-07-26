#! /bin/sh

if !(test -f configure); then
  autoreconf -fsi
fi
if !(test -f Makefile); then
  ./configure
fi
make check
