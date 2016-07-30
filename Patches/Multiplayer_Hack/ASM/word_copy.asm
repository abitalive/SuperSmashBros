// Word copy
// a0 = source
// a1 = destination
// a2 = size
// v0 = temp

pullvar pc, origin

scope WordCopy: {
  lw v0, 0 (a0)
  addiu a2, -0x04
  sw v0, 0 (a1)
  addiu a0, 0x04
  bnez a2, WordCopy
  addiu a1, 0x04
  End:
    jr ra
    nop
}

pushvar origin, pc
