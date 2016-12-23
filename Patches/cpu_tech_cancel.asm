// Super Smash Bros. random CPU tech and Z cancel demonstration

arch n64.cpu
endian msb
//output "", create

include "LIB/N64.inc"

origin 0x0
insert "LIB/Super Smash Bros. (U) [!].z64"

constant Random(0x80018994) // Random integer

constant ChanceForward(30) // Chance to tech roll forward
constant ChanceBackward(30) // Chance to tech roll backward
constant ChanceInPlace(30) // Chance to tech in place

constant ChanceZCancel(90) // Chance to Z cancel

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

origin 0x0BB3C0
base 0x80140980
jal Tech
nop
nop
nop
nop
nop
nop
nop
nop
nop

origin 0x0BE034
base 0x801435F4
jal Tech
nop
nop
nop
nop
nop
nop
nop
nop
nop

origin 0x0CB478
base 0x80150A38
jal ZCancel
nop

origin 0xF5F4E0
base 0x80400000
scope Tech: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  lui t0, 0x800A
  lw t0, 0x50E8 (t0) // Pointer to pointers
  Loop:
    lw t1, 0x78 (t0) // Pointer
    beq t1, s0, CpuCheck
    nop
    addiu t0, 0x74 // Update pointer
    b Loop
    nop
  CpuCheck:
    lbu t2, 0x22 (t0) // Player status
    beqz t2, Original // If status == CPU
    nop
  jal Random
  lli a0, 0x64 // Range
  RollForward:
    sltiu t1, v0, ChanceForward
    beqz t1, RollBackward
    nop
    move a0, s0
    jal 0x80144700 // Tech roll
    lli a1, 0x49 // Forward
    b End
    nop
  RollBackward:
    sltiu t2, v0, (ChanceForward + ChanceBackward)
    beqz t2, InPlace
    nop
    move a0, s0
    jal 0x80144700 // Tech roll
    lli a1, 0x4A // Backward
    b End
    nop
  InPlace:
    sltiu t2, v0, (ChanceForward + ChanceBackward + ChanceInPlace)
    beqz t2, NoTech
    nop
    jal 0x80144660
    move a0, s0
    b End
    nop
  NoTech:
    jal 0x80144498 // No tech
    move a0, s0
    b End
    nop
  Original:
    jal 0x80144760 // Tech roll
    move a0, s0
    bnezl v0, End
    nop
    jal 0x801446BC // Tech in place
    move a0, s0
    bnezl v0, End
    nop
    jal 0x80144498 // No tech
    move a0, s0
    nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

scope ZCancel: {
  addiu sp, -0x20
  sw ra, 0x1C (sp)
  sw v0, 0x10 (sp) // Save v0
  sw v1, 0x14 (sp) // Save v1
  sw a0, 0x18 (sp) // Save a0
  lui t0, 0x800A
  lw t0, 0x50E8 (t0) // Pointer to pointers
  Loop:
    lw t1, 0x78 (t0) // Pointer
    beq t1, a0, CpuCheck
    nop
    addiu t0, 0x74 // Update pointer
    b Loop
    nop
  CpuCheck:
    lbu t2, 0x22 (t0) // Player status
    beqz t2, Original // If status == CPU
    nop
  jal Random
  lli a0, 0x64 // Range
  Cancel:
    sltiu t1, v0, ChanceZCancel
    beqz t1, NoCancel
    nop
    lli at, 0x01
    b End
    nop
  NoCancel:
    lli at, 0x00
    b End
    nop
  Original:
    lw t6, 0x0160 (v1)
    slti at, t6, 0x0B
  End:
    lw v0, 0x10 (sp) // Restore v0
    lw v1, 0x14 (sp) // Restore v1
    lw a0, 0x18 (sp) // Restore a0
    lw ra, 0x1C (sp)
    jr ra
    addiu sp, 0x20
}

