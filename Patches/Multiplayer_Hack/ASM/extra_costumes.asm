// Extra FFA costumes
// Z + C Up: Red team
// Z + C Right: Blue team
// Z + C Down: Green team
// Z + C Left: Extra team

origin 0x1368C8
base 0x80138648
j ExtraCostumes
nop

pullvar pc, origin

scope ExtraCostumes: {
  Z:
    lw t0, 0x24 (sp)
    lhu t0, 0 (t0)
    andi t0, 0x2000 // Z
    beqz t0, End
    nop
  Red:
    lw t0, 0x24 (sp)
    lhu t0, 0x02 (t0)
    andi t0, 0x0008 // C Up
    beqz t0, Blue
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    lli a3, 0x04
    bnez v0, Blue
    nop
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beqz t0, Blue
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    lli a1, 0x04
    b End
    nop
  Blue:
    lw t0, 0x24 (sp)
    lhu t0, 0x02 (t0)
    andi t0, 0x0001 // C Right
    beqz t0, Green
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    lli a3, 0x05
    bnez v0, Green
    nop
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beqz t0, Green
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    lli a1, 0x05
    b End
    nop
  Green:
    lw t0, 0x24 (sp)
    lhu t0, 0x02 (t0)
    andi t0, 0x0004 // C Down
    beqz t0, Extra
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    lli a3, 0x06
    bnez v0, Extra
    nop
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beqz t0, Extra
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    lli a1, 0x06
    b End
    nop
  Extra:
    lw t0, 0x24 (sp)
    lhu t0, 0x02 (t0)
    andi t0, 0x0002 // C Left
    beqz t0, End
    nop
    lw a0, 0x40 (sp)
    lw a1, 0x28 (sp)
    lw a2, 0x1C (sp)
    lw a2, 0x80 (a2)
    jal 0x8013718C
    lli a3, 0x07
    bnez v0, End
    nop
    lw t0, 0x1C (sp)
    lw t0, 0x88 (t0)
    beqz t0, End
    nop
    lw a0, 0x28 (sp)
    jal 0x80137EFC
    lli a1, 0x07
  End:
    lw t0, 0x24 (sp)
    lhu v1, 0x02 (t0)
    j 0x80138678
    lw a1, 0x28 (sp)
}

pushvar origin, pc
