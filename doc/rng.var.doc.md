# Global strucs:

## Content of rng_state:

rng_state contains the state of the RNG, it is layed out as followed.

| Name | Size | Initial value |
|------|------|---------------|
|  a   |1 byte|       1       |
|  x   |1 byte|       0       |
|  y   |1 byte|       0       |
|  z   |1 byte|       0       |

None of those values have any meaning other than being a number.

The initial values are set in rng.init.s