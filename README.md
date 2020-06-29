# The Gameboy of Isaac -- Team Rocket

## Description

This project aims at remaking the popular game *The Binding of Isaac* for Gameboy classic, in assembly. 

Checkout our [blog](https://painsperdus.github.io/gboi-rocket) !

## Features

- Basic room with rocks and walls
- Isaac that can move with animations
- Working collisions !
- In developpement sound system
- Basic room generation (not integrated yet)

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
