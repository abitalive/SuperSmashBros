// Toggle between time/stock on versus css

origin 0x1365A8
base 0x80138328
jal ModeToggle

pullvar pc, origin

scope ModeToggle: {
  addiu sp, -0x18
  sw ra, 0x14 (sp)
  sw a0, 0x10 (sp) // Save a0
  lw t0, 0x74 (a0)
  lw t1, 0x5C (t0) // Y coordinate
  lui t2, 0x4110 // If y coordinate > 9.0
  sltu t3, t1, t2
  bnez t3, Original
  lui t2, 0x4200 // And y coordinate < 32.0
  sltu t3, t1, t2
  beqz t3, Original
  lw t1, 0x58 (t0) // X coordinate
  lui t2, 0x430C // And x coordinate > 140.0
  sltu t3, t1, t2
  bnez t3, Original
  lui t2, 0x433E // And x coordinate < 190.0
  sltu t3, t1, t2
  beqz t3, Original
  nop
  Toggle:
    lui t0, 0x8014
    lw t1, 0xBDAC (t0) // Versus mode
    xori t1, 0x02 // Toggle flag
    sw t1, 0xBDAC (t0) // Store new flag
    lli t2, 0x01
    bne t1, t2, Stock // If versus mode == time
    nop
    Time:
      lui a0, 0x8014
      jal 0x80133FAC // Draw time
      lw a0, 0xBD7C (a0) // Time count
      b Sound
      nop
    Stock:
      lui a0, 0x8014
      jal 0x80134198 // Else draw stock
      lw a0, 0xBD80 (a0) // Stock count
    Sound:
      jal 0x800269C0
      lli a0, 0xA4
  Original:
    jal 0x8013676C // Original instruction
    lw a0, 0x10 (sp) // Restore a0
  End:
    lw ra, 0x14 (sp)
    jr ra
    addiu sp, 0x18
}

pushvar origin, pc
