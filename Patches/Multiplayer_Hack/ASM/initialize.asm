// Initialize

constant DmaSource(0x00F5F4E0) // DMA copy source
constant DmaDestination(0x80400000) // DMA copy destination
constant DmaSize(0x000A0B20) // DMA copy size

origin 0x001234
base 0x80000634
jal Initialize0

origin 0x33204
base 0x80032604
scope Initialize0: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  jal DmaCopy // Original instruction
  nop
  DMA:
    li a0, DmaSource // Source
    la a1, DmaDestination // Destination
    lui a2, (DmaSize >> 16)
    jal DmaCopy
    ori a2, (DmaSize & 0xFFFF) // Size
  jal Initialize1
  nop
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

pullvar pc, origin

scope Initialize1: {
  lui t0, 0x8050
  sb r0, ExtraStagesFlag (t0) // Extra stages flag
  lli t1, 0xFF
  sb t1, TrackLast (t0) // Last track variable
  End:
    jr ra
    nop
}

pushvar origin, pc
