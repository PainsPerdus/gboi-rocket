#!/bin/bash
cd build

wla-gb -I ../ -o object.o ../$1
echo "[objects]" > linkfile
echo "object.o" >> linkfile
wlalink -d -r -v -s linkfile main.gb
rm linkfile object.o
