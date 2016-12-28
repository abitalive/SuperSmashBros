// Super Smash Bros. flash on Z cancel demonstration

arch n64.cpu
endian msb
//output "", create

include "LIB\N64.inc"
include "LIB\macros.inc"

origin 0x0
insert "LIB\Super Smash Bros. (U) [!].z64"

origin 0x0CB528
base 0x80150AE8 // Z cancel
jal Flash

origin 0x33204
base 0x80032604
scope Flash: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal 0x80142D9C // Original instruction
  sw v1, 0x10 (sp) // Save v1
  lw v1, 0x10 (sp) // Restore v1
  lw t0, 0x0160 (v1)
  slti t1, t0, 0x000B
  beqz t1, End // If within frame window
  nop
  Flash:
    lw a0, 0x04 (v1) // Pointer
    //lli a1, 0x08 // Sparkle
    lli a1, 0x2B // Yellow
    jal 0x800E9814 // Flash
    or a2, r0, r0
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}
