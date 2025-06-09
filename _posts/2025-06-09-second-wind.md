---
title: "Second Wind"
date: 2025-06-09
author: Thomas
header:
  teaser: /assets/images/first_release.png
categories:
 - Blog
tags:
 - bugfix
 - feature
---

Oh, it's you. It's been a looong time.

The deadline had passed, and this project went silent. We all went on with our studies,
then our professional lives, and it remained just a fun memory.

I decided to go back to this project, to see how I would fare compared to my
5-year-younger self (and because Z80 Asm is fun). And after a lot of cursing against sloppy
coding practices from back then, I started getting some results. Let's take a look:

## Issue 153

The only **actual** bug that was left unfixed. It was an issue of "Isaac shoots an enemy,
but another one dies". It was actually just a question of non-matching numbers of push/pop,
that became quite obvious once the code commented and cleaned.

## Procedural Generation

When we left, we only had one hardcoded floor, then a second floor where dying was
the only option. This was enough for a demo, but a proper game requires some proper
randomly generated floors.

A floor is a set of connected rooms, placed on a 16x16 grid. The content of each room
is chosen from a set of pre-generated rooms that we had already made.

I wanted a method that is clear and small (speed isn't too much of a constraint as
all of this happens during loading times). So I chose a "monkey with a typewriter" kind
of approach: I randomly pick a slot on the grid, and check if:

1. The slot is not already occupied.
2. The slot is next to at least one other occupied slot.

For the second condition, the most efficient way to check is to compute the manhattan distance
between the candidate and all the other rooms, the distance is 1 when slots are adjacent.
If the candidate doesn't meet the conditions, try again until it does.

The next step was to efficiently place the doors for each room. The most
efficient way I found was to check all pairs of rooms (let's call them A and B) and check
if A is left of B (to set A's right door and B's left door), and if A is above B (to set
A's bottom door and B's top door). The other doors will be set when this pair will be
considered again as B and A.

Finally, I randomly pick a room to put in the slot, and iterate until I find one that
allows the required door layout.

## What Next?

This work seems to have given a second wind to the project. Since, Vi has started to
investigate the fps drops when too many entities are on screen, and Dorian is now
tinkering with the music again. We'll see how it plays out.

