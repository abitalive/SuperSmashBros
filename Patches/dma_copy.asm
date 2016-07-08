// Super Smash Bros. DMA copy demonstration

arch n64.cpu
endian msb
//output "", create

include "LIB\N64.inc"
include "LIB\macros.inc"

origin 0x0
insert "LIB\Super Smash Bros. (U) [!].z64"

// DMA
origin 0x001234
base 0x80000634
jal DMA

origin 0x33204
base 0x80032604
scope DMA: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80002CA0 // Original instruction (DMA Copy)
  nop
  DMA:
    li a0, 0x00F5F4E0 // Source
    la a1, 0x80400000 // Destination
    li a2, 0x000A0B20 // Size
    jal 0x80002CA0 // DMA Copy
    nop
  lw ra, 0x14 (sp)
  jr ra
  addiu sp, 0x18
}
