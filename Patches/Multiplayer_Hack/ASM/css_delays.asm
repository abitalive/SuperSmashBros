// CSS delays

// B pressed on versus CSS
origin 0x136904
base 0x80138684
jal VcssB

// Start pressed on versus CSS
origin 0x138CF0
base 0x8013AA70
nop

// Start pressed on training CSS
origin 0x146DCC
base 0x801377EC
nop

pullvar pc, origin

scope VcssB: {
  lui t0, 0x8014
  lw t0, 0xBDCC (t0) // Versus CSS frame counter
  lli t1, 0x01
  bne t0, t1, End // If counter = 1
  nop
  Skip:
    j 0x801386A0 // Skip
    lw t6, 0x1C (sp)
  End:
    j 0x80137F9C // Else original instruction
    nop
}

pushvar origin, pc
