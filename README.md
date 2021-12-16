# pixelScroll

On a ZX81 plot a random pixel at the bottom of the display,
then scroll the display up one pixel, as fast as the ZX81 can.

Written in Z80 assembly with m4 macro. Ninja build.

![face](demo.gif)

The ZX81 has block characters (0-7 and 128-136). Translate
a given block character to a number between 0 and 15 using:
If the character is between 0 and 7, leave as is, otherwise
subtract it from 143.

The resulting character codes can be ored together.

The same '143' algorithm translates the resulting 0-15
back to a ZX81 block character.
