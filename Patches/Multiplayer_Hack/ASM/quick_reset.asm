// Quick reset

origin 0x109FB8
base 0x8018D0C8
jal QuickReset

origin 0x10B204
base 0x8018E314
j SkipResults
nop
SkipResults_Return:

pullvar pc, origin

scope QuickReset: {
  Input:
    lui t0, 0x8004
    lli t1, 0xF010 // A, B, Z, R, Start
    lli t2, 0x04 // Loop counter
    Loop:
      lhu t3, 0x5228 (t0) // Input
      beq t3, t1, Reset // If input == A, B, Z, R, Start; skip results screen
      addiu t2, -0x01 // Decrement loop counter
      bnez t2, Loop // Break if loop counter == 0
      addiu t0, 0x0A // Update pointer
    b End
    nop
  Reset:
    lui t0, 0x800A
    lli t1, 0x02 // Skip results screen
    sb t1, 0x4AE2 (t0)
    lli t1, 0x07 // Reset
    sb t1, 0x4D19 (t0)
  End:
    j 0x8011485C
    nop
}

scope SkipResults: {
  lui t0, 0x800A
  lbu t0, 0x4AE2 (t0) // Result
  lli t1, 0x02
  bne t0, t1, Original // If result == skip
  nop
  lli t0, 0x10 // Skip results screen
  b End
  nop
  Original:
    lli t0, 0x18 // Else original instruction
  End:
    j SkipResults_Return
    sb t0, 0 (v0)
}

pushvar origin, pc
