// SSS preview y fix

origin 0x14F520
base 0x801339B0
j PreviewYFix
constant PreviewYFix_Return(pc() + 4)

pullvar pc, origin

scope PreviewYFix: {
  lw t0, 0x02E4 (a0) // Preview y
  bnezl t0, End // If preview y != 0
  swc1 f18, 0x02E4 (a0) // Update preview y
  End:
    j PreviewYFix_Return
    swc1 f18, 0x4C (a0) // Original instruction
}

pushvar origin, pc
