# Description of rng.lib.s

Modifies : A, B, H

Returns : A : pseudo-randomly generated value

No arguments

This uses a xorshift algorithm, more precisely, one based on the c version of this one : https://github.com/edrosten/8bit_rng .

The function rng is layed out as followed:
~~~c
void rng() {
    t = x ^ (x << 4);
    h = t ^ (t << 1);
    x = y;
    y = z;
    z = a;
    a = z ^ (z >> 1);
    a = a ^ h
    return a
}
~~~
