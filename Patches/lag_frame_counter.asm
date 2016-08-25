// Super Smash Bros. lag frame counter demonstration
// Game mode must be set to time and time must not set to infinite (so the timer is displayed)

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

origin 0x8E418
base 0x80112C18
j Calculate
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
  lui t0,0x8003
  lw t1, 0x2658 (t0) // Read current value
  lw t2, 0x265C (t0) // Read previous value
  sw t1, 0x265C (t0) // Copy current value to previous value
  beq t1, t2, End
  lw t3, 0x2660 (t0) // Load sum
  subu t4, t1, t2 // Calculate difference between previous and current
  addu t3, t4
  addiu t3, -0x01 // Expect 1 frame difference
  sw t3, 0x2660 (t0) // Save sum
  lui t7, 0x800A // Original instructions
  lw t7, 0x50E8 (t7)
  End:
    j 0x80112C20
    ori v0, t3, r0
}

// Divide
origin 0xAA738
base 0x8012EF38
dw 0x03E8 // 1000
dw 0x0064 // 100
dw 0x000A // 10
dw 0x0001 // 1

origin 0x8E548
base 0x80112D48
or t0, v0, r0

// Load sum instead of timer
origin 0x8E42C
base 0x80112C2C
nop
