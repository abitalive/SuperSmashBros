// Final Destination versus and training fixes

origin 0x080414
base 0x80104C14
jal FinalDestination

pullvar pc, origin

scope FinalDestination: {
  lbu v0, 0x01 (t7) // Original instruction
  lua(t0, ScreenCurrent)
  lbu t0, ScreenCurrent (t0) // Mode
  lli t1, 0x16
  beq t0, t1, TrainingVersus // If mode == versus
  lli t1, 0x36
  beq t0, t1, TrainingVersus // Or mode == training
  nop
  b End
  nop
  TrainingVersus:
    lua(t0, StagePtr)
    lw t0, StagePtr (t0) // Stage pointer
    lbu t0, 0x01 (t0) // Stage
    lli t1, 0x10
    beql t0, t1, End // If stage == Final Destination
    lli v0, 0x0E // Return Battlefield index
  End:
   jr ra
   nop
}

pushvar origin, pc
