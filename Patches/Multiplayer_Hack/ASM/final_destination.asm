// Final Destination versus and training fixes

origin 0x080414
base 0x80104C14
jal FinalDestination

pullvar pc, origin

scope FinalDestination: {
  lbu v0, 0x01 (t7) // Original instruction
  lui t0, 0x800A
  lbu t1, Stage (t0) // Stage
  lli t2, 0x10
  bne t1, t2, End // If stage == Final Destination
  nop
  lbu t1, ScreenCurrent (t0) // Mode
  lli t2, 0x16
  beql t1, t2, End // And mode == versus; return Battlefield index
  lli v0, 0x0E
  lli t2, 0x36
  beql t1, t2, End // Or mode == training; return Battlefield index
  lli v0, 0x0E
  End:
   jr ra
   nop
}

pushvar origin, pc
