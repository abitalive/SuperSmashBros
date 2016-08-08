// Allow full control of time setting on versus css

// Increase time
origin 0x138D78
base 0x8013AAF8
scope TimeIncrease: {
  addiu v0, a0, 0x01
  lli t0, 0x65
  bne v0, t0, End
  nop
  lli v0, 0x01
  End:
    jr ra
    nop
}

// Decrease time
origin 0x138E5C
base 0x8013ABDC
scope TimeDecrease: {
  addiu v0, a0, -0x01
  bnez v0, End
  nop
  lli v0, 0x64
  End:
    jr ra
    nop
}
