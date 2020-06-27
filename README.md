# The Gameboy of Isaac -- Team Rocket

## Description

This project aims at remaking the popular game *The Binding of Isaac* for Gameboy classic, in assembly. 

## Features

For now, we started development with a working Pong game

* Two paddles, one for each player
* The bouncing of the ball depends on where it's been hit
* Sound effects!

## Building

### Build the whole project

	make

### Run in emulator

	make run

### Remove build files

	make clean

### Install to SD Card (for Everdrive cartridge)

You need to modify the `makefile` and change `INSTALL=""` to your SD card mounting point.  
  
	make install
