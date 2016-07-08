// Super Smash Bros. disable anti-aliasing demonstration

arch n64.cpu
endian msb
//output "", create

include "LIB\N64.inc"
include "LIB\macros.inc"

origin 0x0
insert "LIB\Super Smash Bros. (U) [!].z64"

origin 0x1CCC
base 0x800010CC
lui at, 0x0000

origin 0x1DEC
base 0x800011EC
addiu at, r0, 0xFEFF

origin 0x33F0
base 0x800027F0
li v0, 0x00000216
