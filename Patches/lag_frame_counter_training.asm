// Super Smash Bros. lag frame counter (training) demonstration
// Only functional in training mode

arch n64.cpu
endian msb
//output "", create

include "LIB/N64.inc"
include "LIB/macros.inc"

origin 0x0
insert "LIB/Super Smash Bros. (U) [!].z64"

origin 0x31BB8
base 0x80030FB8
jal Increment

origin 0x11498C
base 0x8018E16C
jal Calculate
nop

origin 0x33204
base 0x80032604

scope Increment: {
  lui t0, 0x8003
  lw t1, 0x2658 (t0)
  addiu t1, 0x01 // Add 1 to interrupt counter
  sw t1, 0x2658 (t0)
  j 0x800311a4
  nop
}

scope Calculate: {
  lui t0, 0x8003
  lw t1, 0x2658 (t0) // Read current value
  lw t2, 0x265C (t0) // Read previous value
  sw t1, 0x265C (t0) // Copy current value to previous value
  beq t1, t2, End
  lw a1, 0x2660 (t0) // Load sum
  subu t4, t1, t2 // Calculate difference between previous and current
  addu a1, t4
  addiu a1, -0x01 // Expect 1 frame difference

  slti at, a1, 0x03E8 // 1000
  bnez at, End
  nop
  or a1, r0, r0 // Reset damage counter at 999+

  End:
    jr ra
    sw a1, 0x2660 (t0) // Save sum
}

// Don't reset damage counter after time
origin 0x5D200
base 0x800E1A00
nop
